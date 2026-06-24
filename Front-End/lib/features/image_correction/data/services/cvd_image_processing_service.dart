import 'dart:io';
import 'dart:math' as math;

import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';
import 'package:image/image.dart' as img;

class CvdImageProcessingService {
  const CvdImageProcessingService();

  // DaltonLens reference: Linear RGB -> LMS matrix.
  static const List<List<double>> _linearRgbToLms = [
    [17.8824, 43.5161, 4.11935],
    [3.45565, 27.1554, 3.86714],
    [0.0299566, 0.184309, 1.46709],
  ];

  // Inverse matrix: LMS -> Linear RGB.
  static const List<List<double>> _lmsToLinearRgb = [
    [0.0809444479, -0.130504409, 0.116721066],
    [-0.0102485335, 0.0540193266, -0.113614708],
    [-0.000365296938, -0.00412161469, 0.693511405],
  ];

  // Machado & Oliveira (severity 1.0) simulation matrices in linear RGB.
  static const Map<CvdType, List<List<double>>> _machadoLinearRgbMatrices = {
    CvdType.protan: [
      [0.152286, 1.052583, -0.204868],
      [0.114503, 0.786281, 0.099216],
      [-0.003882, -0.048116, 1.051998],
    ],
    CvdType.deutan: [
      [0.367322, 0.860646, -0.227968],
      [0.280085, 0.672501, 0.047413],
      [-0.01182, 0.04294, 0.968881],
    ],
    CvdType.tritan: [
      [1.255528, -0.076749, -0.178779],
      [-0.078411, 0.930809, 0.147602],
      [0.004733, 0.691367, 0.3039],
    ],
  };

  // Simple daltonization shift matrices used for correction mode.
  static const Map<CvdType, List<List<double>>> _correctionShiftMatrices = {
    CvdType.protan: [
      [0.0, 0.0, 0.0],
      [0.7, 1.0, 0.0],
      [0.7, 0.0, 1.0],
    ],
    CvdType.deutan: [
      [1.0, 0.7, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.7, 1.0],
    ],
    CvdType.tritan: [
      [1.0, 0.0, 0.7],
      [0.0, 1.0, 0.7],
      [0.0, 0.0, 0.0],
    ],
  };

  Future<String> processImage({
    required String imagePath,
    required CvdType cvdType,
    required CvdMode mode,
    double severity = 1.0,
  }) async {
    if (cvdType == CvdType.none) {
      return imagePath;
    }

    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('Failed to decode image for CVD processing.');
    }

    final source = img.Image.from(decoded);
    final output = img.Image.from(source);

    final machadoRgbMatrix = _machadoLinearRgbMatrices[cvdType];
    if (machadoRgbMatrix == null) {
      return imagePath;
    }

    // Convert Machado RGB matrix into LMS-space so we explicitly apply filter
    // after LMS conversion as requested.
    final lmsFilter = _multiply3x3(
      _multiply3x3(_linearRgbToLms, machadoRgbMatrix),
      _lmsToLinearRgb,
    );

    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        final pixel = source.getPixel(x, y);

        // 1) sRGB -> Linear RGB.
        final linearRgb = <double>[
          _srgbToLinear(pixel.r / 255.0),
          _srgbToLinear(pixel.g / 255.0),
          _srgbToLinear(pixel.b / 255.0),
        ];

        // 2) Linear RGB -> LMS.
        final lms = _multiply3x1(_linearRgbToLms, linearRgb);

        // 3) CVD filter application in LMS space (Machado-derived matrix).
        final simulatedLms = _mix3(lms, _multiply3x1(lmsFilter, lms), severity);

        // 4) LMS -> Linear RGB.
        final simulatedLinearRgb = _multiply3x1(_lmsToLinearRgb, simulatedLms);

        final resultLinearRgb =
            mode == CvdMode.simulation
                ? simulatedLinearRgb
                : _applyCorrection(
                  originalLinearRgb: linearRgb,
                  simulatedLinearRgb: simulatedLinearRgb,
                  cvdType: cvdType,
                  severity: severity,
                );

        // 5) Linear RGB -> sRGB.
        final resultSrgb = <int>[
          (_linearToSrgb(resultLinearRgb[0]) * 255).round().clamp(0, 255),
          (_linearToSrgb(resultLinearRgb[1]) * 255).round().clamp(0, 255),
          (_linearToSrgb(resultLinearRgb[2]) * 255).round().clamp(0, 255),
        ];

        output.setPixelRgba(
          x,
          y,
          resultSrgb[0],
          resultSrgb[1],
          resultSrgb[2],
          pixel.a,
        );
      }
    }

    final outputPath = _buildOutputPath(imagePath, cvdType, mode);
    final encoded = _encodeByOutputExtension(outputPath, output);
    await File(outputPath).writeAsBytes(encoded, flush: true);
    return outputPath;
  }

  List<double> _applyCorrection({
    required List<double> originalLinearRgb,
    required List<double> simulatedLinearRgb,
    required CvdType cvdType,
    required double severity,
  }) {
    final shift = _correctionShiftMatrices[cvdType];
    if (shift == null) {
      return simulatedLinearRgb;
    }

    final error = <double>[
      originalLinearRgb[0] - simulatedLinearRgb[0],
      originalLinearRgb[1] - simulatedLinearRgb[1],
      originalLinearRgb[2] - simulatedLinearRgb[2],
    ];

    final shiftedError = _multiply3x1(shift, error);
    final intensity = severity.clamp(0.0, 1.0).toDouble();
    return <double>[
      _clamp01(originalLinearRgb[0] + shiftedError[0] * intensity),
      _clamp01(originalLinearRgb[1] + shiftedError[1] * intensity),
      _clamp01(originalLinearRgb[2] + shiftedError[2] * intensity),
    ];
  }

  String _buildOutputPath(String sourcePath, CvdType type, CvdMode mode) {
    final ext = _getExtension(sourcePath);
    final extension = ext.isEmpty ? 'png' : ext;
    final tag = mode == CvdMode.simulation ? 'sim' : 'corr';
    final fileName =
        'cvd_${tag}_${type.name}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    return '${Directory.systemTemp.path}${Platform.pathSeparator}$fileName';
  }

  List<int> _encodeByOutputExtension(String outputPath, img.Image image) {
    final ext = _getExtension(outputPath);
    if (ext == 'jpg' || ext == 'jpeg') {
      return img.encodeJpg(image, quality: 95);
    }
    return img.encodePng(image, level: 2);
  }

  String _getExtension(String path) {
    final fileName = path.split(Platform.pathSeparator).last;
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  List<double> _multiply3x1(List<List<double>> matrix, List<double> vector) {
    return <double>[
      matrix[0][0] * vector[0] +
          matrix[0][1] * vector[1] +
          matrix[0][2] * vector[2],
      matrix[1][0] * vector[0] +
          matrix[1][1] * vector[1] +
          matrix[1][2] * vector[2],
      matrix[2][0] * vector[0] +
          matrix[2][1] * vector[1] +
          matrix[2][2] * vector[2],
    ];
  }

  List<List<double>> _multiply3x3(List<List<double>> a, List<List<double>> b) {
    return List<List<double>>.generate(3, (i) {
      return List<double>.generate(3, (j) {
        return a[i][0] * b[0][j] + a[i][1] * b[1][j] + a[i][2] * b[2][j];
      });
    });
  }

  List<double> _mix3(List<double> from, List<double> to, double amount) {
    final t = amount.clamp(0.0, 1.0).toDouble();
    return <double>[
      from[0] + (to[0] - from[0]) * t,
      from[1] + (to[1] - from[1]) * t,
      from[2] + (to[2] - from[2]) * t,
    ];
  }

  double _srgbToLinear(double c) {
    if (c <= 0.04045) {
      return c / 12.92;
    }
    return math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  double _linearToSrgb(double c) {
    final value = _clamp01(c);
    if (value <= 0.0031308) {
      return value * 12.92;
    }
    return 1.055 * math.pow(value, 1 / 2.4).toDouble() - 0.055;
  }

  double _clamp01(double value) {
    return value.clamp(0.0, 1.0).toDouble();
  }
}

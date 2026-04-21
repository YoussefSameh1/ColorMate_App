import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class DominantColorExtractor {
  const DominantColorExtractor();

  Future<Size> getImageSize(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw Exception('Failed to decode image for size extraction.');
    }

    return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }

  Future<Color> extractFromImagePath({
    required String imagePath,
    required Rect cropRect,
  }) async {
    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('Failed to decode image for color extraction.');
    }

    final maxX = decoded.width - 1;
    final maxY = decoded.height - 1;

    final left = cropRect.left.floor().clamp(0, maxX);
    final top = cropRect.top.floor().clamp(0, maxY);
    final right = cropRect.right.ceil().clamp(left + 1, decoded.width);
    final bottom = cropRect.bottom.ceil().clamp(top + 1, decoded.height);

    final cropWidth = (right - left).clamp(1, decoded.width);
    final cropHeight = (bottom - top).clamp(1, decoded.height);

    final cropped = img.copyCrop(
      decoded,
      x: left,
      y: top,
      width: cropWidth,
      height: cropHeight,
    );

    return _calculateDominantColor(cropped);
  }

  Color _calculateDominantColor(img.Image image) {
    final resized = _resizeForColorAnalysis(image);
    final sampledColors = _sampleColorsForClustering(resized);
    if (sampledColors.isEmpty) {
      return const Color(0xFFFFFFFF);
    }

    final clusters = _runWeightedKMeans(sampledColors, k: 3, iterations: 7);
    if (clusters.isEmpty) {
      return sampledColors.first.color;
    }

    _ColorCluster bestCluster = clusters.first;
    var bestScore = -1.0;
    for (final cluster in clusters) {
      final hsv = HSVColor.fromColor(cluster.centroidColor);
      final score =
          cluster.totalWeight *
          (0.75 + (hsv.saturation * 0.9) + (hsv.value * 0.2));
      if (score > bestScore) {
        bestScore = score;
        bestCluster = cluster;
      }
    }

    return bestCluster.centroidColor;
  }

  List<_SampledColor> _sampleColorsForClustering(img.Image image) {
    final samples = <_SampledColor>[];
    final startX = (image.width * 0.08).floor();
    final endX = (image.width * 0.92).ceil();
    final startY = (image.height * 0.08).floor();
    final endY = (image.height * 0.92).ceil();

    final centerX = image.width / 2;
    final centerY = image.height / 2;
    final maxDistance = math
        .sqrt(centerX * centerX + centerY * centerY)
        .clamp(1, double.infinity);

    final estimatedPixels = (endX - startX) * (endY - startY);
    final stride = math.max(1, math.sqrt(estimatedPixels / 1200).round());

    for (var y = startY; y < endY; y += stride) {
      for (var x = startX; x < endX; x += stride) {
        final pixel = image.getPixel(x, y);
        if (pixel.a.toInt() < 100) {
          continue;
        }

        final color = Color.fromARGB(
          255,
          pixel.r.toInt(),
          pixel.g.toInt(),
          pixel.b.toInt(),
        );
        final hsv = HSVColor.fromColor(color);

        if (hsv.value < 0.08 || hsv.value > 0.98) {
          continue;
        }

        final dx = (x - centerX).toDouble();
        final dy = (y - centerY).toDouble();
        final distance = math.sqrt(dx * dx + dy * dy);
        final centerWeight = (1.0 - (distance / maxDistance) * 0.72).clamp(
          0.18,
          1.0,
        );
        final saturationWeight = 0.65 + (hsv.saturation * 1.35);
        final valueWeight = 0.75 + (hsv.value * 0.45);

        samples.add(
          _SampledColor(
            color: color,
            weight: (centerWeight * saturationWeight * valueWeight).toDouble(),
          ),
        );
      }
    }

    return samples;
  }

  List<_ColorCluster> _runWeightedKMeans(
    List<_SampledColor> samples, {
    required int k,
    required int iterations,
  }) {
    if (samples.isEmpty) {
      return const [];
    }

    final distinctSeeds = <Color>[];
    for (final sample in samples) {
      if (!distinctSeeds.any(
        (seed) => _colorDistance(seed, sample.color) < 28,
      )) {
        distinctSeeds.add(sample.color);
      }
      if (distinctSeeds.length == k) {
        break;
      }
    }

    while (distinctSeeds.length < k) {
      distinctSeeds.add(samples[distinctSeeds.length % samples.length].color);
    }

    var centroids = distinctSeeds;
    final assignments = List<int>.filled(samples.length, 0);

    for (var iteration = 0; iteration < iterations; iteration++) {
      for (var index = 0; index < samples.length; index++) {
        final sample = samples[index];
        var bestCluster = 0;
        var bestDistance = double.infinity;

        for (
          var clusterIndex = 0;
          clusterIndex < centroids.length;
          clusterIndex++
        ) {
          final distance = _colorDistance(
            sample.color,
            centroids[clusterIndex],
          );
          if (distance < bestDistance) {
            bestDistance = distance;
            bestCluster = clusterIndex;
          }
        }

        assignments[index] = bestCluster;
      }

      final sumR = List<double>.filled(k, 0);
      final sumG = List<double>.filled(k, 0);
      final sumB = List<double>.filled(k, 0);
      final totalWeights = List<double>.filled(k, 0);

      for (var index = 0; index < samples.length; index++) {
        final clusterIndex = assignments[index];
        final sample = samples[index];
        final weight = sample.weight;

        sumR[clusterIndex] += sample.color.red * weight;
        sumG[clusterIndex] += sample.color.green * weight;
        sumB[clusterIndex] += sample.color.blue * weight;
        totalWeights[clusterIndex] += weight;
      }

      final nextCentroids = <Color>[];
      for (var clusterIndex = 0; clusterIndex < k; clusterIndex++) {
        final totalWeight = totalWeights[clusterIndex];
        if (totalWeight <= 0) {
          nextCentroids.add(centroids[clusterIndex]);
          continue;
        }

        nextCentroids.add(
          Color.fromARGB(
            255,
            (sumR[clusterIndex] / totalWeight).round().clamp(0, 255),
            (sumG[clusterIndex] / totalWeight).round().clamp(0, 255),
            (sumB[clusterIndex] / totalWeight).round().clamp(0, 255),
          ),
        );
      }

      centroids = nextCentroids;
    }

    final clusterWeight = List<double>.filled(k, 0);
    for (var index = 0; index < samples.length; index++) {
      final clusterIndex = assignments[index];
      clusterWeight[clusterIndex] += samples[index].weight;
    }

    final clusters = <_ColorCluster>[];
    for (var clusterIndex = 0; clusterIndex < k; clusterIndex++) {
      clusters.add(
        _ColorCluster(
          centroidColor: centroids[clusterIndex],
          totalWeight: clusterWeight[clusterIndex],
        ),
      );
    }

    return clusters;
  }

  double _colorDistance(Color a, Color b) {
    final redDistance = (a.red - b.red).toDouble();
    final greenDistance = (a.green - b.green).toDouble();
    final blueDistance = (a.blue - b.blue).toDouble();
    return math.sqrt(
      (redDistance * redDistance) +
          (greenDistance * greenDistance) +
          (blueDistance * blueDistance),
    );
  }

  img.Image _resizeForColorAnalysis(img.Image image) {
    const maxDimension = 120;
    if (image.width <= maxDimension && image.height <= maxDimension) {
      return image;
    }

    if (image.width >= image.height) {
      final scaledHeight = (image.height * maxDimension / image.width).round();
      return img.copyResize(
        image,
        width: maxDimension,
        height: scaledHeight.clamp(1, maxDimension),
        interpolation: img.Interpolation.average,
      );
    }

    final scaledWidth = (image.width * maxDimension / image.height).round();
    return img.copyResize(
      image,
      width: scaledWidth.clamp(1, maxDimension),
      height: maxDimension,
      interpolation: img.Interpolation.average,
    );
  }
}

class _SampledColor {
  final Color color;
  final double weight;

  const _SampledColor({required this.color, required this.weight});
}

class _ColorCluster {
  final Color centroidColor;
  final double totalWeight;

  const _ColorCluster({required this.centroidColor, required this.totalWeight});
}

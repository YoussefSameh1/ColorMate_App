import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';

class CvdFilterItemData {
  const CvdFilterItemData({
    required this.id,
    required this.title,
    required this.type,
    required this.previewAsset,
    this.simulationPreviewAsset,
    this.correctionPreviewAsset,
  });

  final String id;
  final String title;
  final CvdType type;
  final String previewAsset;
  final String? simulationPreviewAsset;
  final String? correctionPreviewAsset;

  CvdFilterOption toDomain() {
    return CvdFilterOption(
      id: id,
      title: title,
      type: type,
      previewAsset: previewAsset,
      simulationPreviewAsset: simulationPreviewAsset,
      correctionPreviewAsset: correctionPreviewAsset,
    );
  }
}

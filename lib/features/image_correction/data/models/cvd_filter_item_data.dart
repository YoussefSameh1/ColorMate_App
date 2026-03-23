import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';

class CvdFilterItemData {
  const CvdFilterItemData({
    required this.id,
    required this.title,
    required this.type,
    required this.previewAsset,
  });

  final String id;
  final String title;
  final CvdType type;
  final String previewAsset;

  CvdFilterOption toDomain() {
    return CvdFilterOption(
      id: id,
      title: title,
      type: type,
      previewAsset: previewAsset,
    );
  }
}

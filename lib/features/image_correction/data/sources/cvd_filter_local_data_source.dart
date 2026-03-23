import 'package:colormate_app/features/image_correction/data/models/cvd_filter_item_data.dart';
import 'package:colormate_app/features/image_correction/domain/entities/cvd_filter_option.dart';

class CvdFilterLocalDataSource {
  const CvdFilterLocalDataSource();

  Future<List<CvdFilterItemData>> getFilterOptions() async {
    // This data source is intentionally isolated so it can be replaced later
    // with API/DB-backed filters without changing presentation logic.
    return const [
      CvdFilterItemData(
        id: 'none',
        title: 'Original',
        type: CvdType.none,
        previewAsset: 'assets/images/object_detection_sample.png',
      ),
      CvdFilterItemData(
        id: 'protan',
        title: 'Protan',
        type: CvdType.protan,
        previewAsset: 'assets/images/test_sample.png',
      ),
      CvdFilterItemData(
        id: 'deutan',
        title: 'Deutan',
        type: CvdType.deutan,
        previewAsset: 'assets/images/outfit_sample.png',
      ),
      CvdFilterItemData(
        id: 'tritan',
        title: 'Tritan',
        type: CvdType.tritan,
        previewAsset: 'assets/images/object_detection_sample.png',
      ),
    ];
  }
}

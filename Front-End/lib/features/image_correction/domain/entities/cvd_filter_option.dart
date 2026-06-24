enum CvdType { none, protan, deutan, tritan }

enum CvdMode { simulation, correction }

class CvdFilterOption {
  const CvdFilterOption({
    required this.id,
    required this.title,
    required this.type,
    this.previewAsset,
    this.simulationPreviewAsset,
    this.correctionPreviewAsset,
  });

  final String id;
  final String title;
  final CvdType type;
  final String? previewAsset;
  final String? simulationPreviewAsset;
  final String? correctionPreviewAsset;

  String? previewAssetForMode(CvdMode mode) {
    if (mode == CvdMode.correction) {
      return correctionPreviewAsset ?? previewAsset;
    }

    return simulationPreviewAsset ?? previewAsset;
  }
}

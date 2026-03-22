enum CvdType { none, protan, deutan, tritan }

enum CvdMode { simulation, correction }

class CvdFilterOption {
  const CvdFilterOption({
    required this.id,
    required this.title,
    required this.type,
    this.previewAsset,
  });

  final String id;
  final String title;
  final CvdType type;
  final String? previewAsset;
}

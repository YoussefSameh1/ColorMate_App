import 'package:flutter/material.dart';
import 'filter_item_model.dart';

class ImageCorrectionViewModel extends ChangeNotifier {
  final List<FilterItemModel> filters = const [
    FilterItemModel(
      title: 'Original',
      imageAsset: 'assets/images/object_detection_sample.png',
    ),
    FilterItemModel(
      title: 'My Filter',
      imageAsset: 'assets/images/test_sample.png',
    ),
    FilterItemModel(
      title: 'Tritanopia Filter',
      imageAsset: 'assets/images/outfit_sample.png',
    ),
    FilterItemModel(
      title: 'Deuteranopia Filter',
      imageAsset: 'assets/images/object_detection_sample.png',
    ),
  ];

  int _selectedFilterIndex = 0; 

  int get selectedFilterIndex => _selectedFilterIndex;

  void selectFilter(int index) {
    if (_selectedFilterIndex != index) {
      _selectedFilterIndex = index;
      notifyListeners();
    }
  }

  void resetSelection() {
    _selectedFilterIndex = 0;
    notifyListeners();
  }
}

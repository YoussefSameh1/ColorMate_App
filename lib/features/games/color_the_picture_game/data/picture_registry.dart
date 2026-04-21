import 'package:colormate_app/features/games/color_the_picture_game/data/models/colorable_section_model.dart';
import 'package:colormate_app/features/games/color_the_picture_game/data/pictures_data.dart';

class PictureInfo {
  final String name;
  final String emoji;
  final List<ColorableSectionModel> Function() builder;

  const PictureInfo({
    required this.name,
    required this.emoji,
    required this.builder,
  });
}

final List<PictureInfo> allPictures = [
  PictureInfo(name: 'House', emoji: '🏠', builder: buildHouse),
  PictureInfo(name: 'Flower', emoji: '🌸', builder: buildFlower),
  PictureInfo(name: 'Sun', emoji: '☀️', builder: buildSun),
  PictureInfo(name: 'Rainbow', emoji: '🌈', builder: buildRainbow),
  PictureInfo(name: 'Apple', emoji: '🍎', builder: buildApple),
  PictureInfo(name: 'Tree', emoji: '🌳', builder: buildTree),
  PictureInfo(name: 'Tree', emoji: '🌳', builder: buildTree2),
  PictureInfo(name: 'Car', emoji: '🚗', builder: buildCar),
  PictureInfo(name: 'Boat', emoji: '⛵', builder: buildBoat),
  PictureInfo(name: 'Rocket', emoji: '🚀', builder: buildRocket),
  PictureInfo(name: 'Snowman', emoji: '⛄', builder: buildSnowman),
  PictureInfo(name: 'Butterfly', emoji: '🦋', builder: buildButterfly),
  PictureInfo(name: 'Cat', emoji: '🐱', builder: buildCat),
  PictureInfo(name: 'Dog', emoji: '🐶', builder: buildDog),
];

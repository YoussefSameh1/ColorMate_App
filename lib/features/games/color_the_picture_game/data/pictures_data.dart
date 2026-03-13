import 'dart:ui';

import 'package:colormate_app/features/games/color_the_picture_game/data/models/colorable_section_model.dart';

List<ColorableSectionModel> buildHouse() => [
  // Roof
  ColorableSectionModel(
    name: 'Roof',
    correctColor: 'Red',
    points: [
      const Offset(0.25, 0.42),
      const Offset(0.50, 0.20),
      const Offset(0.75, 0.42),
    ],
  ),
  // Wall
  ColorableSectionModel(
    name: 'Wall',
    correctColor: 'Orange',
    points: [
      const Offset(0.28, 0.42),
      const Offset(0.72, 0.42),
      const Offset(0.72, 0.78),
      const Offset(0.28, 0.78),
    ],
  ),
  // Door
  ColorableSectionModel(
    name: 'Door',
    correctColor: 'Brown',
    points: [
      const Offset(0.43, 0.60),
      const Offset(0.57, 0.60),
      const Offset(0.57, 0.78),
      const Offset(0.43, 0.78),
    ],
  ),
  // Window left
  ColorableSectionModel(
    name: 'Window Left',
    correctColor: 'Yellow',
    points: [
      const Offset(0.32, 0.48),
      const Offset(0.42, 0.48),
      const Offset(0.42, 0.57),
      const Offset(0.32, 0.57),
    ],
  ),
  // Window right
  ColorableSectionModel(
    name: 'Window Right',
    correctColor: 'Yellow',
    points: [
      const Offset(0.58, 0.48),
      const Offset(0.68, 0.48),
      const Offset(0.68, 0.57),
      const Offset(0.58, 0.57),
    ],
  ),
  // Chimney
  ColorableSectionModel(
    name: 'Chimney',
    correctColor: 'Brown',
    points: [
      const Offset(0.60, 0.22),
      const Offset(0.67, 0.22),
      const Offset(0.67, 0.38),
      const Offset(0.60, 0.38),
    ],
  ),
  // Ground / lawn
  ColorableSectionModel(
    name: 'Lawn',
    correctColor: 'Green',
    points: [
      const Offset(0.05, 0.78),
      const Offset(0.95, 0.78),
      const Offset(0.95, 0.92),
      const Offset(0.05, 0.92),
    ],
  ),
  // Clouds
  ColorableSectionModel(
    name: 'Cloud Left',
    correctColor: 'Blue',
    points: [
      const Offset(0.10, 0.10),
      const Offset(0.25, 0.10),
      const Offset(0.25, 0.18),
      const Offset(0.10, 0.18),
    ],
  ),
  ColorableSectionModel(
    name: 'Cloud Right',
    correctColor: 'Blue',
    points: [
      const Offset(0.75, 0.10),
      const Offset(0.90, 0.10),
      const Offset(0.90, 0.18),
      const Offset(0.75, 0.18),
    ],
  ),
];

List<ColorableSectionModel> buildFlower() => [
  ColorableSectionModel(
    name: 'Flower Center',
    correctColor: 'Yellow',
    points: [
      const Offset(0.50, 0.30),
      const Offset(0.55, 0.30),
      const Offset(0.55, 0.35),
      const Offset(0.50, 0.35),
    ],
  ),
  ColorableSectionModel(
    name: 'Petal Top',
    correctColor: 'Red',
    points: [
      const Offset(0.50, 0.20),
      const Offset(0.55, 0.25),
      const Offset(0.50, 0.30),
      const Offset(0.45, 0.25),
    ],
  ),
  ColorableSectionModel(
    name: 'Petal Right',
    correctColor: 'Red',
    points: [
      const Offset(0.60, 0.30),
      const Offset(0.55, 0.35),
      const Offset(0.55, 0.30),
      const Offset(0.60, 0.25),
    ],
  ),
  ColorableSectionModel(
    name: 'Petal Bottom',
    correctColor: 'Red',
    points: [
      const Offset(0.50, 0.40),
      const Offset(0.45, 0.35),
      const Offset(0.50, 0.35),
      const Offset(0.55, 0.35),
    ],
  ),
  ColorableSectionModel(
    name: 'Petal Left',
    correctColor: 'Red',
    points: [
      const Offset(0.40, 0.30),
      const Offset(0.45, 0.25),
      const Offset(0.50, 0.30),
      const Offset(0.45, 0.35),
    ],
  ),
  ColorableSectionModel(
    name: 'Stem',
    correctColor: 'Green',
    points: [
      const Offset(0.48, 0.40),
      const Offset(0.52, 0.40),
      const Offset(0.52, 0.70),
      const Offset(0.48, 0.70),
    ],
  ),
  ColorableSectionModel(
    name: 'Leaf Left',
    correctColor: 'Green',
    points: [
      const Offset(0.48, 0.50),
      const Offset(0.35, 0.52),
      const Offset(0.40, 0.55),
      const Offset(0.48, 0.53),
    ],
  ),
  ColorableSectionModel(
    name: 'Leaf Right',
    correctColor: 'Green',
    points: [
      const Offset(0.52, 0.60),
      const Offset(0.65, 0.62),
      const Offset(0.60, 0.65),
      const Offset(0.52, 0.63),
    ],
  ),
];

List<ColorableSectionModel> buildSun() => [
  // Sun Body: Octagon for a rounder appearance
  ColorableSectionModel(
    name: 'Sun Body',
    correctColor: 'Yellow',
    points: const [
      Offset(0.45, 0.30),
      Offset(0.55, 0.30),
      Offset(0.60, 0.35),
      Offset(0.60, 0.45),
      Offset(0.55, 0.50),
      Offset(0.45, 0.50),
      Offset(0.40, 0.45),
      Offset(0.40, 0.35),
    ],
  ),
  // Compass Rays (Triangles)
  ColorableSectionModel(
    name: 'Ray Top',
    correctColor: 'Orange',
    points: const [Offset(0.50, 0.15), Offset(0.54, 0.28), Offset(0.46, 0.28)],
  ),
  ColorableSectionModel(
    name: 'Ray Bottom',
    correctColor: 'Orange',
    points: const [Offset(0.50, 0.65), Offset(0.46, 0.52), Offset(0.54, 0.52)],
  ),
  ColorableSectionModel(
    name: 'Ray Left',
    correctColor: 'Orange',
    points: const [Offset(0.25, 0.40), Offset(0.38, 0.36), Offset(0.38, 0.44)],
  ),
  ColorableSectionModel(
    name: 'Ray Right',
    correctColor: 'Orange',
    points: const [Offset(0.75, 0.40), Offset(0.62, 0.44), Offset(0.62, 0.36)],
  ),
  // Diagonal Rays (Triangles)
  ColorableSectionModel(
    name: 'Ray Top-Left',
    correctColor: 'Orange',
    points: const [
      Offset(0.32, 0.22), // Tip
      Offset(0.45, 0.30), // Base 1 (Corresponds to Sun Body point)
      Offset(0.40, 0.35), // Base 2 (Corresponds to Sun Body point)
    ],
  ),
  ColorableSectionModel(
    name: 'Ray Top-Right',
    correctColor: 'Orange',
    points: const [
      Offset(0.68, 0.22), // Tip
      Offset(0.55, 0.30), // Base 1
      Offset(0.60, 0.35), // Base 2
    ],
  ),
  ColorableSectionModel(
    name: 'Ray Bottom-Left',
    correctColor: 'Orange',
    points: const [
      Offset(0.32, 0.58), // Tip
      Offset(0.40, 0.45), // Base 1
      Offset(0.45, 0.50), // Base 2
    ],
  ),
  ColorableSectionModel(
    name: 'Ray Bottom-Right',
    correctColor: 'Orange',
    points: const [
      Offset(0.68, 0.58), // Tip
      Offset(0.60, 0.45), // Base 1
      Offset(0.55, 0.50), // Base 2
    ],
  ),
  // Clouds
  ColorableSectionModel(
    name: 'Cloud Left',
    correctColor: 'Blue',
    points: const [
      Offset(0.10, 0.20),
      Offset(0.25, 0.20),
      Offset(0.25, 0.28),
      Offset(0.10, 0.28),
    ],
  ),
  ColorableSectionModel(
    name: 'Cloud Right',
    correctColor: 'Blue',
    points: const [
      Offset(0.75, 0.20),
      Offset(0.90, 0.20),
      Offset(0.90, 0.28),
      Offset(0.75, 0.28),
    ],
  ),
  // Ground
  ColorableSectionModel(
    name: 'Ground',
    correctColor: 'Green',
    points: const [
      Offset(0.0, 0.80),
      Offset(1.0, 0.80),
      Offset(1.0, 1.0),
      Offset(0.0, 1.0),
    ],
  ),
];

List<ColorableSectionModel> buildRainbow() => [
  // Red Arc
  ColorableSectionModel(
    name: 'Red Arc',
    correctColor: 'Red',
    points: const [
      Offset(0.05, 0.80),
      Offset(0.25, 0.40),
      Offset(0.50, 0.30),
      Offset(0.75, 0.40),
      Offset(0.95, 0.80),
      Offset(0.90, 0.80),
      Offset(0.72, 0.45),
      Offset(0.50, 0.36),
      Offset(0.28, 0.45),
      Offset(0.10, 0.80),
    ],
  ),
  // Orange Arc
  ColorableSectionModel(
    name: 'Orange Arc',
    correctColor: 'Orange',
    points: const [
      Offset(0.10, 0.80),
      Offset(0.28, 0.45),
      Offset(0.50, 0.36),
      Offset(0.72, 0.45),
      Offset(0.90, 0.80),
      Offset(0.85, 0.80),
      Offset(0.69, 0.50),
      Offset(0.50, 0.42),
      Offset(0.31, 0.50),
      Offset(0.15, 0.80),
    ],
  ),
  // Yellow Arc
  ColorableSectionModel(
    name: 'Yellow Arc',
    correctColor: 'Yellow',
    points: const [
      Offset(0.15, 0.80),
      Offset(0.31, 0.50),
      Offset(0.50, 0.42),
      Offset(0.69, 0.50),
      Offset(0.85, 0.80),
      Offset(0.80, 0.80),
      Offset(0.66, 0.55),
      Offset(0.50, 0.48),
      Offset(0.34, 0.55),
      Offset(0.20, 0.80),
    ],
  ),
  // Green Arc
  ColorableSectionModel(
    name: 'Green Arc',
    correctColor: 'Green',
    points: const [
      Offset(0.20, 0.80),
      Offset(0.34, 0.55),
      Offset(0.50, 0.48),
      Offset(0.66, 0.55),
      Offset(0.80, 0.80),
      Offset(0.75, 0.80),
      Offset(0.63, 0.60),
      Offset(0.50, 0.54),
      Offset(0.37, 0.60),
      Offset(0.25, 0.80),
    ],
  ),
  // Blue Arc
  ColorableSectionModel(
    name: 'Blue Arc',
    correctColor: 'Blue',
    points: const [
      Offset(0.25, 0.80),
      Offset(0.37, 0.60),
      Offset(0.50, 0.54),
      Offset(0.63, 0.60),
      Offset(0.75, 0.80),
      Offset(0.70, 0.80),
      Offset(0.60, 0.65),
      Offset(0.50, 0.60),
      Offset(0.40, 0.65),
      Offset(0.30, 0.80),
    ],
  ),
  // Violet Arc - Now connects directly to the bottom of Blue
  ColorableSectionModel(
    name: 'Purple Arc',
    correctColor: 'Purple',
    points: const [
      Offset(0.30, 0.80),
      Offset(0.40, 0.65),
      Offset(0.50, 0.60),
      Offset(0.60, 0.65),
      Offset(0.70, 0.80),
      Offset(0.65, 0.80),
      Offset(0.55, 0.72),
      Offset(0.50, 0.68),
      Offset(0.45, 0.72),
      Offset(0.35, 0.80),
    ],
  ),
];

List<ColorableSectionModel> buildApple() => [
  // Apple Body: 8 points to create a rounded, organic shape
  ColorableSectionModel(
    name: 'Apple Body',
    correctColor: 'Red',
    points: const [
      Offset(0.50, 0.38), // Top center dip
      Offset(0.65, 0.35), // Top right shoulder
      Offset(0.75, 0.55), // Right side
      Offset(0.65, 0.80), // Bottom right curve
      Offset(0.50, 0.85), // Bottom center
      Offset(0.35, 0.80), // Bottom left curve
      Offset(0.25, 0.55), // Left side
      Offset(0.35, 0.35), // Top left shoulder
    ],
  ),
  // Stem: Tapered and slightly offset
  ColorableSectionModel(
    name: 'Stem',
    correctColor: 'Brown',
    points: const [
      Offset(0.47, 0.20),
      Offset(0.53, 0.20),
      Offset(0.52, 0.38),
      Offset(0.48, 0.38),
    ],
  ),
  // Leaf: A more natural almond shape
  ColorableSectionModel(
    name: 'Leaf',
    correctColor: 'Green',
    points: const [
      Offset(0.53, 0.28), // Connected to stem
      Offset(0.65, 0.15), // Leaf tip
      Offset(0.75, 0.25), // Outer curve
      Offset(0.55, 0.35), // Bottom curve
    ],
  ),
];

List<ColorableSectionModel> buildTree() => [
  ColorableSectionModel(
    name: 'Leaves',
    correctColor: 'Green',
    points: [
      const Offset(0.30, 0.30),
      const Offset(0.70, 0.30),
      const Offset(0.70, 0.55),
      const Offset(0.30, 0.55),
    ],
  ),

  ColorableSectionModel(
    name: 'Trunk',
    correctColor: 'Brown',
    points: [
      const Offset(0.46, 0.55),
      const Offset(0.54, 0.55),
      const Offset(0.54, 0.80),
      const Offset(0.46, 0.80),
    ],
  ),
];

List<ColorableSectionModel> buildTree2() => [
  // Bottom foliage layer
  ColorableSectionModel(
    name: 'Bottom Leaves',
    correctColor: 'Green',
    points: [
      const Offset(0.15, 0.55),
      const Offset(0.85, 0.55),
      const Offset(0.72, 0.70),
      const Offset(0.28, 0.70),
    ],
  ),
  // Middle foliage layer
  ColorableSectionModel(
    name: 'Middle Leaves',
    correctColor: 'Green',
    points: [
      const Offset(0.22, 0.38),
      const Offset(0.78, 0.38),
      const Offset(0.68, 0.55),
      const Offset(0.32, 0.55),
    ],
  ),
  // Top foliage layer
  ColorableSectionModel(
    name: 'Top Leaves',
    correctColor: 'Green',
    points: [
      const Offset(0.30, 0.22),
      const Offset(0.70, 0.22),
      const Offset(0.62, 0.38),
      const Offset(0.38, 0.38),
    ],
  ),
  // Trunk
  ColorableSectionModel(
    name: 'Trunk',
    correctColor: 'Brown',
    points: [
      const Offset(0.43, 0.70),
      const Offset(0.57, 0.70),
      const Offset(0.57, 0.88),
      const Offset(0.43, 0.88),
    ],
  ),
  // Apple left
  ColorableSectionModel(
    name: 'Apple Left',
    correctColor: 'Red',
    points: [
      const Offset(0.28, 0.44),
      const Offset(0.36, 0.44),
      const Offset(0.36, 0.52),
      const Offset(0.28, 0.52),
    ],
  ),
  // Apple right
  ColorableSectionModel(
    name: 'Apple Right',
    correctColor: 'Red',
    points: [
      const Offset(0.64, 0.44),
      const Offset(0.72, 0.44),
      const Offset(0.72, 0.52),
      const Offset(0.64, 0.52),
    ],
  ),
  // Ground
  ColorableSectionModel(
    name: 'Ground',
    correctColor: 'Green',
    points: [
      const Offset(0.05, 0.88),
      const Offset(0.95, 0.88),
      const Offset(0.95, 0.96),
      const Offset(0.05, 0.96),
    ],
  ),
];

List<ColorableSectionModel> buildCar() => [
  // Car body (lower)
  ColorableSectionModel(
    name: 'Car Body',
    correctColor: 'Red',
    points: [
      const Offset(0.08, 0.52),
      const Offset(0.92, 0.52),
      const Offset(0.92, 0.72),
      const Offset(0.08, 0.72),
    ],
  ),
  // Car roof (cabin)
  ColorableSectionModel(
    name: 'Car Roof',
    correctColor: 'Red',
    points: [
      const Offset(0.25, 0.34),
      const Offset(0.75, 0.34),
      const Offset(0.82, 0.52),
      const Offset(0.18, 0.52),
    ],
  ),
  // Windshield
  ColorableSectionModel(
    name: 'Windshield',
    correctColor: 'Blue',
    points: [
      const Offset(0.52, 0.36),
      const Offset(0.72, 0.36),
      const Offset(0.78, 0.52),
      const Offset(0.52, 0.52),
    ],
  ),
  // Rear window
  ColorableSectionModel(
    name: 'Rear Window',
    correctColor: 'Blue',
    points: [
      const Offset(0.28, 0.36),
      const Offset(0.48, 0.36),
      const Offset(0.48, 0.52),
      const Offset(0.22, 0.52),
    ],
  ),
  // Left wheel
  ColorableSectionModel(
    name: 'Left Wheel',
    correctColor: 'Black',
    points: [
      const Offset(0.14, 0.66),
      const Offset(0.30, 0.66),
      const Offset(0.30, 0.80),
      const Offset(0.14, 0.80),
    ],
  ),
  // Right wheel
  ColorableSectionModel(
    name: 'Right Wheel',
    correctColor: 'Black',
    points: [
      const Offset(0.70, 0.66),
      const Offset(0.86, 0.66),
      const Offset(0.86, 0.80),
      const Offset(0.70, 0.80),
    ],
  ),
  // Left hubcap
  ColorableSectionModel(
    name: 'Left Hubcap',
    correctColor: 'Yellow',
    points: [
      const Offset(0.18, 0.68),
      const Offset(0.26, 0.68),
      const Offset(0.26, 0.78),
      const Offset(0.18, 0.78),
    ],
  ),
  // Right hubcap
  ColorableSectionModel(
    name: 'Right Hubcap',
    correctColor: 'Yellow',
    points: [
      const Offset(0.74, 0.68),
      const Offset(0.82, 0.68),
      const Offset(0.82, 0.78),
      const Offset(0.74, 0.78),
    ],
  ),
  // Headlight
  ColorableSectionModel(
    name: 'Headlight',
    correctColor: 'Yellow',
    points: [
      const Offset(0.84, 0.54),
      const Offset(0.92, 0.54),
      const Offset(0.92, 0.62),
      const Offset(0.84, 0.62),
    ],
  ),
  // Road
  ColorableSectionModel(
    name: 'Road',
    correctColor: 'Brown',
    points: [
      const Offset(0.05, 0.80),
      const Offset(0.95, 0.80),
      const Offset(0.95, 0.92),
      const Offset(0.05, 0.92),
    ],
  ),
];

List<ColorableSectionModel> buildBoat() => [
  // Sky - Expanded to cover the upper background
  ColorableSectionModel(
    name: 'Sky',
    correctColor: 'Blue',
    points: const [
      Offset(0.0, 0.0),
      Offset(1.0, 0.0),
      Offset(1.0, 0.40),
      Offset(0.0, 0.40),
    ],
  ),
  // Water - Expanded to cover the lower background
  ColorableSectionModel(
    name: 'Water',
    correctColor: 'Blue',
    points: const [
      Offset(0.0, 0.70),
      Offset(1.0, 0.70),
      Offset(1.0, 1.0),
      Offset(0.0, 1.0),
    ],
  ),
  // Hull - Pointed at the front (left side)
  ColorableSectionModel(
    name: 'Hull',
    correctColor: 'Red',
    points: const [
      Offset(0.10, 0.58), // Sharp bow
      Offset(0.85, 0.58), // Stern top
      Offset(0.80, 0.75), // Stern bottom
      Offset(0.25, 0.75), // Hull bottom curve
    ],
  ),
  // Deck
  ColorableSectionModel(
    name: 'Deck',
    correctColor: 'Brown',
    points: const [
      Offset(0.15, 0.54),
      Offset(0.85, 0.54),
      Offset(0.85, 0.58),
      Offset(0.15, 0.58),
    ],
  ),
  // Cabin
  ColorableSectionModel(
    name: 'Cabin',
    correctColor: 'Yellow',
    points: const [
      Offset(0.55, 0.36),
      Offset(0.80, 0.36),
      Offset(0.80, 0.54),
      Offset(0.55, 0.54),
    ],
  ),
  // Cabin window
  ColorableSectionModel(
    name: 'Cabin Window',
    correctColor: 'Blue',
    points: const [
      Offset(0.60, 0.40),
      Offset(0.75, 0.40),
      Offset(0.75, 0.48),
      Offset(0.60, 0.48),
    ],
  ),
  // Mast
  ColorableSectionModel(
    name: 'Mast',
    correctColor: 'Brown',
    points: const [
      Offset(0.39, 0.10),
      Offset(0.41, 0.10),
      Offset(0.41, 0.54),
      Offset(0.39, 0.54),
    ],
  ),
  // Main Sail - 4 points to simulate a wind curve
  ColorableSectionModel(
    name: 'Main Sail',
    correctColor: 'Orange',
    points: const [
      Offset(0.41, 0.12),
      Offset(0.70, 0.30), // Outer curve
      Offset(0.65, 0.50), // Bottom corner
      Offset(0.41, 0.50),
    ],
  ),
  // Front Sail (Jib)
  ColorableSectionModel(
    name: 'Front Sail',
    correctColor: 'Orange',
    points: const [Offset(0.39, 0.12), Offset(0.39, 0.50), Offset(0.18, 0.50)],
  ),
];

List<ColorableSectionModel> buildRocket() => [
  // Nose cone
  ColorableSectionModel(
    name: 'Nose Cone',
    correctColor: 'Red',
    points: [
      const Offset(0.50, 0.08),
      const Offset(0.62, 0.26),
      const Offset(0.38, 0.26),
    ],
  ),
  // Rocket body
  ColorableSectionModel(
    name: 'Rocket Body',
    correctColor: 'Blue',
    points: [
      const Offset(0.38, 0.26),
      const Offset(0.62, 0.26),
      const Offset(0.62, 0.66),
      const Offset(0.38, 0.66),
    ],
  ),
  // Window
  ColorableSectionModel(
    name: 'Window',
    correctColor: 'Black',
    points: [
      const Offset(0.43, 0.34),
      const Offset(0.57, 0.34),
      const Offset(0.57, 0.46),
      const Offset(0.43, 0.46),
    ],
  ),
  // Left fin
  ColorableSectionModel(
    name: 'Left Fin',
    correctColor: 'Red',
    points: [
      const Offset(0.38, 0.56),
      const Offset(0.22, 0.72),
      const Offset(0.22, 0.66),
      const Offset(0.38, 0.66),
    ],
  ),
  // Right fin
  ColorableSectionModel(
    name: 'Right Fin',
    correctColor: 'Red',
    points: [
      const Offset(0.62, 0.56),
      const Offset(0.62, 0.66),
      const Offset(0.78, 0.66),
      const Offset(0.78, 0.72),
    ],
  ),
  // Exhaust nozzle
  ColorableSectionModel(
    name: 'Nozzle',
    correctColor: 'Red',
    points: [
      const Offset(0.42, 0.66),
      const Offset(0.58, 0.66),
      const Offset(0.55, 0.74),
      const Offset(0.45, 0.74),
    ],
  ),
  // Flame left
  ColorableSectionModel(
    name: 'Flame Left',
    correctColor: 'Yellow',
    points: [
      const Offset(0.45, 0.74),
      const Offset(0.50, 0.74),
      const Offset(0.46, 0.88),
      const Offset(0.38, 0.80),
    ],
  ),
  // Flame right
  ColorableSectionModel(
    name: 'Flame Right',
    correctColor: 'Yellow',
    points: [
      const Offset(0.50, 0.74),
      const Offset(0.55, 0.74),
      const Offset(0.62, 0.80),
      const Offset(0.54, 0.88),
    ],
  ),
];

List<ColorableSectionModel> buildSnowman() => [
  // Bottom ball
  ColorableSectionModel(
    name: 'Bottom Ball',
    correctColor: 'Blue',
    points: const [
      Offset(0.28, 0.60),
      Offset(0.72, 0.60),
      Offset(0.72, 0.88),
      Offset(0.28, 0.88),
    ],
  ),
  // Middle ball
  ColorableSectionModel(
    name: 'Middle Ball',
    correctColor: 'Blue',
    points: const [
      Offset(0.33, 0.38),
      Offset(0.67, 0.38),
      Offset(0.67, 0.62),
      Offset(0.33, 0.62),
    ],
  ),
  // Left Hand (Stick)
  ColorableSectionModel(
    name: 'Left Hand',
    correctColor: 'Black',
    points: const [
      Offset(0.15, 0.40), // Hand tip
      Offset(0.33, 0.48), // Upper attachment
      Offset(0.33, 0.52), // Lower attachment
      Offset(0.16, 0.44), // Bottom edge
    ],
  ),
  // Right Hand (Stick)
  ColorableSectionModel(
    name: 'Right Hand',
    correctColor: 'Black',
    points: const [
      Offset(0.67, 0.48), // Upper attachment
      Offset(0.85, 0.40), // Hand tip
      Offset(0.84, 0.44), // Bottom edge
      Offset(0.67, 0.52), // Lower attachment
    ],
  ),
  // Head
  ColorableSectionModel(
    name: 'Head',
    correctColor: 'Blue',
    points: const [
      Offset(0.37, 0.18),
      Offset(0.63, 0.18),
      Offset(0.63, 0.40),
      Offset(0.37, 0.40),
    ],
  ),
  // Hat brim
  ColorableSectionModel(
    name: 'Hat Brim',
    correctColor: 'Red',
    points: const [
      Offset(0.30, 0.14),
      Offset(0.70, 0.14),
      Offset(0.70, 0.20),
      Offset(0.30, 0.20),
    ],
  ),
  // Hat top
  ColorableSectionModel(
    name: 'Hat Top',
    correctColor: 'Black',
    points: const [
      Offset(0.38, 0.02),
      Offset(0.62, 0.02),
      Offset(0.62, 0.14),
      Offset(0.38, 0.14),
    ],
  ),
  // Eyes
  ColorableSectionModel(
    name: 'Left Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.41, 0.22),
      Offset(0.46, 0.22),
      Offset(0.46, 0.28),
      Offset(0.41, 0.28),
    ],
  ),
  ColorableSectionModel(
    name: 'Right Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.54, 0.22),
      Offset(0.59, 0.22),
      Offset(0.59, 0.28),
      Offset(0.54, 0.28),
    ],
  ),
  // Carrot nose
  ColorableSectionModel(
    name: 'Nose',
    correctColor: 'Orange',
    points: const [
      Offset(0.48, 0.28),
      Offset(0.52, 0.28),
      Offset(0.56, 0.32),
      Offset(0.44, 0.32),
    ],
  ),
  // Scarf
  ColorableSectionModel(
    name: 'Scarf',
    correctColor: 'Red',
    points: const [
      Offset(0.33, 0.38),
      Offset(0.67, 0.38),
      Offset(0.67, 0.44),
      Offset(0.33, 0.44),
    ],
  ),
  // Buttons
  ColorableSectionModel(
    name: 'Button Top',
    correctColor: 'Black',
    points: const [
      Offset(0.47, 0.46),
      Offset(0.53, 0.46),
      Offset(0.53, 0.52),
      Offset(0.47, 0.52),
    ],
  ),
  ColorableSectionModel(
    name: 'Button Bottom',
    correctColor: 'Black',
    points: const [
      Offset(0.47, 0.54),
      Offset(0.53, 0.54),
      Offset(0.53, 0.60),
      Offset(0.47, 0.60),
    ],
  ),
  // Snow ground
  ColorableSectionModel(
    name: 'Snow Ground',
    correctColor: 'Blue',
    points: const [
      Offset(0.05, 0.88),
      Offset(0.95, 0.88),
      Offset(0.95, 0.96),
      Offset(0.05, 0.96),
    ],
  ),
];

List<ColorableSectionModel> buildButterfly() => [
  // --- THE BODY (Segmented and Sculpted) ---
  // Head (Rounded)
  ColorableSectionModel(
    name: 'Head',
    correctColor: 'Brown',
    points: const [
      Offset(0.48, 0.18), Offset(0.52, 0.18), // Top
      Offset(0.55, 0.22), Offset(0.52, 0.26), // Right side
      Offset(0.48, 0.26), Offset(0.45, 0.22), // Left side
    ],
  ),
  // Thorax (Wider, muscle section)
  ColorableSectionModel(
    name: 'Thorax',
    correctColor: 'Brown',
    points: const [
      Offset(0.48, 0.26), Offset(0.52, 0.26), // Connect to Head
      Offset(0.56, 0.35), Offset(0.54, 0.45), // Right curve
      Offset(0.46, 0.45), Offset(0.44, 0.35), // Left curve
    ],
  ),
  // Abdomen (Long, segmented, tapered)
  ColorableSectionModel(
    name: 'Abdomen',
    correctColor: 'Brown',
    points: const [
      Offset(0.48, 0.45), Offset(0.52, 0.45), // Connect to Thorax
      Offset(0.54, 0.55), Offset(0.52, 0.75), // Right Taper
      Offset(0.50, 0.85), // Tail Tip
      Offset(0.48, 0.75), Offset(0.46, 0.55), // Left Taper
    ],
  ),

  // --- THE WINGS (Complex, Rounded Curves) ---
  // Forewing (Top-Left): Broad, powerful curve
  ColorableSectionModel(
    name: 'Forewing Left',
    correctColor: 'Orange',
    points: const [
      Offset(0.46, 0.28), // Thorax attachment
      Offset(0.25, 0.08), // Apex (Top point)
      Offset(0.08, 0.25), // Outer Margin Top
      Offset(0.12, 0.48), // Outer Margin Bottom
      Offset(0.30, 0.55), // Inner Margin
      Offset(0.46, 0.42), // Bottom attachment
    ],
  ),
  // Forewing (Top-Right)
  ColorableSectionModel(
    name: 'Forewing Right',
    correctColor: 'Orange',
    points: const [
      Offset(0.54, 0.28),
      Offset(0.75, 0.08),
      Offset(0.92, 0.25),
      Offset(0.88, 0.48),
      Offset(0.70, 0.55),
      Offset(0.54, 0.42),
    ],
  ),
  // Hindwing (Bottom-Left): Tapered, delicate curve
  ColorableSectionModel(
    name: 'Hindwing Left',
    correctColor: 'Orange',
    points: const [
      Offset(0.46, 0.45), // Upper attachment
      Offset(0.30, 0.55), // Top Margin
      Offset(0.15, 0.65), // Outer Margin
      Offset(0.25, 0.85), // Bottom Margin
      Offset(0.44, 0.80), // Anal Margin
      Offset(0.48, 0.65), // Abdomen connection
    ],
  ),
  // Hindwing (Bottom-Right)
  ColorableSectionModel(
    name: 'Hindwing Right',
    correctColor: 'Orange',
    points: const [
      Offset(0.54, 0.45),
      Offset(0.70, 0.55),
      Offset(0.85, 0.65),
      Offset(0.75, 0.85),
      Offset(0.56, 0.80),
      Offset(0.52, 0.65),
    ],
  ),

  // --- PATTERNS & SPOTS (Complex, Segmented Designs) ---
  // Main Spots (Eyespot pattern on Forewings)
  ColorableSectionModel(
    name: 'Eyespot Left',
    correctColor: 'Blue',
    points: const [
      Offset(0.20, 0.25),
      Offset(0.26, 0.30),
      Offset(0.22, 0.38),
      Offset(0.16, 0.35),
    ],
  ),
  ColorableSectionModel(
    name: 'Eyespot Right',
    correctColor: 'Blue',
    points: const [
      Offset(0.80, 0.25),
      Offset(0.74, 0.30),
      Offset(0.78, 0.38),
      Offset(0.84, 0.35),
    ],
  ),
  // Inner Marks (Pattern elements on Hindwings)
  ColorableSectionModel(
    name: 'Pattern Left',
    correctColor: 'Pink',
    points: const [
      Offset(0.30, 0.68),
      Offset(0.38, 0.72),
      Offset(0.34, 0.78),
      Offset(0.28, 0.75),
    ],
  ),
  ColorableSectionModel(
    name: 'Pattern Right',
    correctColor: 'Pink',
    points: const [
      Offset(0.70, 0.68),
      Offset(0.62, 0.72),
      Offset(0.66, 0.78),
      Offset(0.72, 0.75),
    ],
  ),
  // Margin Detailing (Monarch-style dots on edges)
  ColorableSectionModel(
    name: 'Margin Dots Left',
    correctColor: 'Purple',
    points: const [
      Offset(0.12, 0.28),
      Offset(0.10, 0.34),
      Offset(0.10, 0.40),
      Offset(0.14, 0.46),
    ],
  ),
  ColorableSectionModel(
    name: 'Margin Dots Right',
    correctColor: 'Purple',
    points: const [
      Offset(0.88, 0.28),
      Offset(0.90, 0.34),
      Offset(0.90, 0.40),
      Offset(0.86, 0.46),
    ],
  ),

  // --- APPENDAGES ---
  // Antennae (Tapered)
  ColorableSectionModel(
    name: 'Antenna Left',
    correctColor: 'Black',
    points: const [
      Offset(0.48, 0.05), Offset(0.49, 0.05), // Tip
      Offset(0.48, 0.18), Offset(0.47, 0.18), // Base
    ],
  ),
  ColorableSectionModel(
    name: 'Antenna Right',
    correctColor: 'Black',
    points: const [
      Offset(0.52, 0.05),
      Offset(0.51, 0.05),
      Offset(0.52, 0.18),
      Offset(0.53, 0.18),
    ],
  ),
];

List<ColorableSectionModel> buildCat() => [
  // --- THE BODY (Rounded and grounded) ---
  ColorableSectionModel(
    name: 'Body',
    correctColor: 'Orange',
    points: const [
      Offset(0.35, 0.55), Offset(0.65, 0.55), // Top
      Offset(0.75, 0.65), Offset(0.75, 0.85), // Right side
      Offset(0.65, 0.95), Offset(0.35, 0.95), // Bottom (Ground)
      Offset(0.25, 0.85), Offset(0.25, 0.65), // Left side
    ],
  ),
  // Belly Patch
  ColorableSectionModel(
    name: 'Belly',
    correctColor: 'Yellow',
    points: const [
      Offset(0.40, 0.65),
      Offset(0.60, 0.65),
      Offset(0.65, 0.75),
      Offset(0.60, 0.85),
      Offset(0.40, 0.85),
      Offset(0.35, 0.75),
    ],
  ),

  // --- THE HEAD (Sculpted) ---
  ColorableSectionModel(
    name: 'Head',
    correctColor: 'Orange',
    points: const [
      Offset(0.38, 0.30), Offset(0.62, 0.30), // Top
      Offset(0.70, 0.40), Offset(0.68, 0.55), // Right
      Offset(0.50, 0.62), // Chin dip
      Offset(0.32, 0.55), Offset(0.30, 0.40), // Left
    ],
  ),

  // Ears (More organic triangles)
  ColorableSectionModel(
    name: 'Left Ear',
    correctColor: 'Orange',
    points: const [Offset(0.32, 0.32), Offset(0.30, 0.12), Offset(0.45, 0.30)],
  ),
  ColorableSectionModel(
    name: 'Right Ear',
    correctColor: 'Orange',
    points: const [Offset(0.55, 0.30), Offset(0.70, 0.12), Offset(0.68, 0.32)],
  ),
  ColorableSectionModel(
    name: 'Inner Left Ear',
    correctColor: 'Yellow',
    points: const [Offset(0.34, 0.28), Offset(0.32, 0.18), Offset(0.42, 0.28)],
  ),
  ColorableSectionModel(
    name: 'Inner Right Ear',
    correctColor: 'Yellow',
    points: const [Offset(0.58, 0.28), Offset(0.68, 0.18), Offset(0.66, 0.28)],
  ),

  // --- FACE DETAILS ---
  // Eyes (Diamond/Cat-eye shape)
  ColorableSectionModel(
    name: 'Left Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.38, 0.42),
      Offset(0.42, 0.38),
      Offset(0.46, 0.42),
      Offset(0.42, 0.46),
    ],
  ),
  ColorableSectionModel(
    name: 'Right Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.54, 0.42),
      Offset(0.58, 0.38),
      Offset(0.62, 0.42),
      Offset(0.58, 0.46),
    ],
  ),
  // Muzzle & Nose
  ColorableSectionModel(
    name: 'Nose',
    correctColor: 'Pink',
    points: const [Offset(0.48, 0.50), Offset(0.52, 0.50), Offset(0.50, 0.54)],
  ),

  // --- EXTREMITIES ---
  // Tail (Curved upward)
  ColorableSectionModel(
    name: 'Tail',
    correctColor: 'Orange',
    points: const [
      Offset(0.75, 0.75), // Attachment
      Offset(0.88, 0.50), // Mid curve
      Offset(0.95, 0.45), // Tip top
      Offset(0.92, 0.55), // Tip bottom
      Offset(0.82, 0.85), // Lower curve
    ],
  ),
  // Paws
  ColorableSectionModel(
    name: 'Left Paw',
    correctColor: 'Orange',
    points: const [
      Offset(0.30, 0.90),
      Offset(0.40, 0.90),
      Offset(0.42, 0.98),
      Offset(0.28, 0.98),
    ],
  ),
  ColorableSectionModel(
    name: 'Right Paw',
    correctColor: 'Orange',
    points: const [
      Offset(0.60, 0.90),
      Offset(0.70, 0.90),
      Offset(0.72, 0.98),
      Offset(0.58, 0.98),
    ],
  ),
];

List<ColorableSectionModel> buildDog() => [
  // Head
  ColorableSectionModel(
    name: 'Head',
    correctColor: 'Yellow', // Closest to the light tan emoji face
    points: const [
      Offset(0.28, 0.22),
      Offset(0.72, 0.22),
      Offset(0.72, 0.55),
      Offset(0.28, 0.55),
    ],
  ),

  // Left Ear
  ColorableSectionModel(
    name: 'Left Ear',
    correctColor: 'Brown', // Dark floppy ears
    points: const [
      Offset(0.18, 0.22),
      Offset(0.32, 0.22),
      Offset(0.30, 0.50),
      Offset(0.16, 0.46),
    ],
  ),

  // Right Ear
  ColorableSectionModel(
    name: 'Right Ear',
    correctColor: 'Brown',
    points: const [
      Offset(0.68, 0.22),
      Offset(0.82, 0.22),
      Offset(0.84, 0.46),
      Offset(0.70, 0.50),
    ],
  ),

  // Left Eye
  ColorableSectionModel(
    name: 'Left Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.34, 0.30),
      Offset(0.44, 0.30),
      Offset(0.44, 0.40),
      Offset(0.34, 0.40),
    ],
  ),

  // Right Eye
  ColorableSectionModel(
    name: 'Right Eye',
    correctColor: 'Black',
    points: const [
      Offset(0.56, 0.30),
      Offset(0.66, 0.30),
      Offset(0.66, 0.40),
      Offset(0.56, 0.40),
    ],
  ),

  // Nose
  ColorableSectionModel(
    name: 'Nose',
    correctColor: 'Black',
    points: const [Offset(0.46, 0.44), Offset(0.54, 0.44), Offset(0.50, 0.50)],
  ),

  // Mouth
  ColorableSectionModel(
    name: 'Mouth',
    correctColor: 'Pink', // Using Pink for the tongue/mouth line
    points: const [
      Offset(0.44, 0.52),
      Offset(0.56, 0.52),
      Offset(0.56, 0.54),
      Offset(0.44, 0.54),
    ],
  ),

  // Body
  ColorableSectionModel(
    name: 'Body',
    correctColor: 'Yellow',
    points: const [
      Offset(0.25, 0.56),
      Offset(0.75, 0.56),
      Offset(0.75, 0.82),
      Offset(0.25, 0.82),
    ],
  ),

  // Belly
  ColorableSectionModel(
    name: 'Belly',
    correctColor: 'Brown', // Using Brown to match the light snout
    points: const [
      Offset(0.38, 0.58),
      Offset(0.62, 0.58),
      Offset(0.62, 0.80),
      Offset(0.38, 0.80),
    ],
  ),

  // Tail
  ColorableSectionModel(
    name: 'Tail',
    correctColor: 'Yellow',
    points: const [
      Offset(0.75, 0.60),
      Offset(0.88, 0.50),
      Offset(0.92, 0.56),
      Offset(0.78, 0.70),
    ],
  ),

  // Back Left Leg
  ColorableSectionModel(
    name: 'Back Left Leg',
    correctColor: 'Yellow',
    points: const [
      Offset(0.38, 0.82),
      Offset(0.45, 0.82),
      Offset(0.45, 0.92),
      Offset(0.38, 0.92),
    ],
  ),

  // Back Right Leg
  ColorableSectionModel(
    name: 'Back Right Leg',
    correctColor: 'Yellow',
    points: const [
      Offset(0.55, 0.82),
      Offset(0.62, 0.82),
      Offset(0.62, 0.92),
      Offset(0.55, 0.92),
    ],
  ),
];

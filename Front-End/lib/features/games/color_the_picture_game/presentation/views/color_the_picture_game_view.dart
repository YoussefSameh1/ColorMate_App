import 'package:colormate_app/core/utils/constants.dart';
import 'package:colormate_app/features/games/color_the_picture_game/data/models/colorable_section_model.dart';
import 'package:colormate_app/features/games/color_the_picture_game/data/picture_registry.dart';
import 'package:colormate_app/features/games/presentation/views/widgets/simple_game_appbar.dart';
import 'package:flutter/material.dart';

class ColorThePictureGameView extends StatefulWidget {
  const ColorThePictureGameView({super.key});

  @override
  State<ColorThePictureGameView> createState() =>
      _ColorThePictureGameViewState();
}

class _ColorThePictureGameViewState extends State<ColorThePictureGameView>
    with SingleTickerProviderStateMixin {
  final Map<String, Color> colorPalette = {
    'Red': Colors.red,
    'Orange': Colors.orange,
    'Yellow': Colors.yellow,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Purple': Colors.purple,
    'Brown': Colors.brown,
    'Pink': Colors.pink,
    'Black': Colors.black,
  };

  String? selectedColor;
  late List<ColorableSectionModel> sections;
  int currentPictureIndex = 0;
  late AnimationController _celebrationController;

  PictureInfo get currentPicture => allPictures[currentPictureIndex];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    initializePicture();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void initializePicture() {
    setState(() {
      sections = currentPicture.builder();
      selectedColor = null;
    });
  }

  void switchPicture(int index) {
    setState(() {
      currentPictureIndex = index;
    });
    initializePicture();
  }

  void colorSection(ColorableSectionModel section) {
    if (selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a color first!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      section.currentColor = selectedColor;

      if (selectedColor == section.correctColor) {
        _celebrationController.forward(from: 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${section.name} should be ${section.correctColor}!'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }

      bool allCorrect = sections.every((s) => s.currentColor == s.correctColor);
      if (allCorrect) {
        Future.delayed(const Duration(milliseconds: 500), showWinDialog);
      }
    });
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('🎨 ${currentPicture.emoji} Perfect Coloring!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You colored the ${currentPicture.name} perfectly!'),
                const SizedBox(height: 10),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  initializePicture();
                },
                child: const Text('Color Again'),
              ),
              if (currentPictureIndex < allPictures.length - 1)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    switchPicture(currentPictureIndex + 1);
                  },
                  child: const Text('Next Picture →'),
                ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleGameAppBar(
        title: 'Color the ${currentPicture.name} ${currentPicture.emoji}',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.orange.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ── Picture selector ──────────────────────────────────────────
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: allPictures.length,
                  itemBuilder: (context, index) {
                    final pic = allPictures[index];
                    final isActive = index == currentPictureIndex;
                    return GestureDetector(
                      onTap: () => switchPicture(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.pink : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color:
                                isActive
                                    ? Colors.pink.shade700
                                    : Colors.grey.shade300,
                            width: isActive ? 2.5 : 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(
                                isActive ? 0.3 : 0.0,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              pic.emoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pic.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isActive
                                        ? Colors.white
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Tap a section, then tap a color!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Selected color indicator
              if (selectedColor != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorPalette[selectedColor]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: colorPalette[selectedColor]!,
                      width: 3,
                    ),
                  ),
                  child: Text(
                    'Selected: $selectedColor',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // ── Drawing canvas ────────────────────────────────────────────
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade400, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: CustomPaint(
                      painter: SectionPainter(sections: sections),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            onTapDown: (details) {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final local = box.globalToLocal(
                                details.globalPosition,
                              );
                              final rx = local.dx / constraints.maxWidth;
                              final ry = local.dy / constraints.maxHeight;

                              for (var section in sections.reversed) {
                                if (isPointInPolygon(
                                  Offset(rx, ry),
                                  section.points,
                                )) {
                                  colorSection(section);
                                  break;
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ── Color palette ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
                child: Column(
                  children: [
                    const Text(
                      'Color Palette:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children:
                          colorPalette.entries.map((entry) {
                            final isSelected = selectedColor == entry.key;
                            return GestureDetector(
                              onTap:
                                  () =>
                                      setState(() => selectedColor = entry.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: isSelected ? 66 : 56,
                                height: isSelected ? 66 : 56,
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : Colors.white,
                                    width: isSelected ? 4 : 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: entry.value.withOpacity(0.5),
                                      blurRadius: isSelected ? 15 : 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              ElevatedButton.icon(
                onPressed: initializePicture,
                icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
                label: const Text(
                  'Clear Picture',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  bool isPointInPolygon(Offset point, List<Offset> polygon) {
    bool inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if ((polygon[i].dy > point.dy) != (polygon[j].dy > point.dy) &&
          point.dx <
              (polygon[j].dx - polygon[i].dx) *
                      (point.dy - polygon[i].dy) /
                      (polygon[j].dy - polygon[i].dy) +
                  polygon[i].dx) {
        inside = !inside;
      }
    }
    return inside;
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

const Map<String, Color> _colorMap = {
  'Red': Colors.red,
  'Orange': Colors.orange,
  'Yellow': Colors.yellow,
  'Green': Colors.green,
  'Blue': Colors.blue,
  'Purple': Colors.purple,
  'Brown': Colors.brown,
  'Pink': Colors.pink,
  'Black': Colors.black,
};

class SectionPainter extends CustomPainter {
  final List<ColorableSectionModel> sections;

  SectionPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    for (var section in sections) {
      final fillPaint =
          Paint()
            ..color =
                section.currentColor != null
                    ? _colorMap[section.currentColor]!
                    : Colors.grey.shade200
            ..style = PaintingStyle.fill;

      final path = Path();
      final points =
          section.points
              .map((p) => Offset(p.dx * size.width, p.dy * size.height))
              .toList();

      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();

      canvas.drawPath(path, fillPaint);

      final outlinePaint =
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;
      canvas.drawPath(path, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(SectionPainter oldDelegate) => true;
}

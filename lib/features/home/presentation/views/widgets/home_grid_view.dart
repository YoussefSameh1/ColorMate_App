import 'package:colormate_app/features/home/data/features_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeGridView extends StatelessWidget {
  const HomeGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.5;
    final itemHeight = (availableHeight - 36) / 3;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 66) / 2;
    // 66 = padding + spacing
    final aspectRatio = itemWidth / itemHeight;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: aspectRatio,
      children:
          features.map((item) {
            return GestureDetector(
              onTap: () => GoRouter.of(context).push(item.route),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: LinearGradient(
                    colors: [
                      item.color.withOpacity(0.85),
                      item.color.withOpacity(0.65),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final iconSize = constraints.maxHeight * 0.25;
                    final textSize = constraints.maxHeight * 0.12;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(iconSize * 0.5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.08),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: textSize,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }).toList(),
    );
  }
}

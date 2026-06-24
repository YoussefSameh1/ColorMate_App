import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasketWidget extends StatelessWidget {
  final Map basket;
  final Function(String) onAccept;

  const BasketWidget({super.key, required this.basket, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 65,
          height: 100,
          decoration: BoxDecoration(
            color: basket['color'].withOpacity(hovering ? 0.7 : 0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(basket['icon'], color: basket['color'], size: 30.sp),
              Text(
                basket['colorName'],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

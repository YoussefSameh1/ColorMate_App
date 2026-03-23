import 'package:colormate_app/features/games/color_collector_game/data/models/falling_object_model.dart';
import 'package:flutter/material.dart';

class FallingObjectWidget extends StatelessWidget {
  final FallingObject object;
  final Function() onDragStart;
  final Function() onDragEnd;

  const FallingObjectWidget({
    super.key,
    required this.object,
    required this.onDragStart,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: object.x,
      top: object.y,
      child: Draggable<String>(
        data: object.id,
        onDragStarted: onDragStart,
        onDragEnd: (_) => onDragEnd(),
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(scale: 1.3, child: _objectBox()),
        ),
        childWhenDragging: Container(),
        child: _objectBox(),
      ),
    );
  }

  Widget _objectBox() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(object.emoji, style: const TextStyle(fontSize: 45)),
      ),
    );
  }
}

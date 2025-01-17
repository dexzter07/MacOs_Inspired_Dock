import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DockItem extends StatelessWidget {
  final int index;
  final DockController controller = Get.find<DockController>();

  DockItem({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (draggedDetails) {
        controller.updateHoverIndex(index);
        return true;
      },
      onAcceptWithDetails: (details) {
        controller.reorderItems(details.data, index);
      },
      onLeave: (_) {
        controller.updateHoverIndex(null);
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            if (controller.draggedIndex.value == null) {
              controller.updateHoverIndex(index);
            }
          },
          onExit: (_) {
            if (controller.draggedIndex.value == null) {
              controller.updateHoverIndex(null);
            }
          },
          child: Draggable<int>(
            data: index,
            feedback: Material(
              color: Colors.transparent,
              child: _buildAnimatedItem(true),
            ),
            onDragStarted: () {
              controller.updateDraggedIndex(index);
              controller.updateHoverIndex(null);
            },
            onDragEnd: (_) {
              controller.updateDraggedIndex(null);
            },
            childWhenDragging: Opacity(
              opacity: 0.0,
              child: _buildAnimatedItem(false),
            ),
            child: _buildAnimatedItem(false),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(bool isDragging) {
    return Obx(
      () => AnimatedContainer(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 48),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(
            controller.getTranslationX(index),
            controller.getTranslationY(index),
            0.0,
          ),
        height: controller.getScaledSize(index),
        width: controller.getScaledSize(index),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: controller.items[index].color,
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Icon(
          controller.items[index].icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

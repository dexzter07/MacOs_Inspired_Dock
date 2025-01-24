import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DockItem extends StatefulWidget {
  final int index;

  const DockItem({super.key, required this.index});

  @override
  State<DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<DockItem> {
  final DockController controller = Get.find<DockController>();

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (draggedDetails) {
        controller.updateHoveredIndex(widget.index);
        return true;
      },
      onAcceptWithDetails: (details) {
        controller.reorderItems(details.data, widget.index);
      },
      onLeave: (_) {
        controller.updateHoveredIndex(null);
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => controller.updateHoveredIndex(widget.index),
          onExit: (_) => controller.updateHoveredIndex(null),
          child: Draggable<int>(
            data: widget.index,
            feedback: Obx(() => buildDockIcon(true)),
            childWhenDragging: const SizedBox.shrink(),
            onDragStarted: () => controller.updateDraggedIndex(widget.index),
            onDragEnd: (_) {
              controller.updateDraggedIndex(null);
              controller.setDockHovered(false);
            },
            child: Obx(() => buildDockIcon(false)),
          ),
        );
      },
    );
  }

  Widget buildDockIcon(bool isDragging) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: controller.calculateScaledSize(widget.index),
      height: controller.calculateScaledSize(widget.index),
      margin: EdgeInsets.symmetric(
        horizontal: controller.spacing / 2,
      ),
      decoration: BoxDecoration(
        color: controller.items[widget.index].color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: Icon(
        controller.items[widget.index].icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

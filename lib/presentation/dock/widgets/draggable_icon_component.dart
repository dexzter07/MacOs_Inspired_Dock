import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';

/// widget for an individual item in the dock.
class DockItem extends StatefulWidget {
  /// The index of the item in the dock.
  final int index;

  const DockItem({super.key, required this.index});

  @override
  State<DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<DockItem> {
  /// The controller responsible for managing state.
  final DockController _dockController = Get.find<DockController>();

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (draggedDetails) {
        _dockController.updateHoveredIndex(widget.index);
        return true; // Allows the drag-and-drop operation
      },
      onAcceptWithDetails: (details) {
        _dockController.reorderItems(
            details.data, widget.index); // Reorders items
      },
      onLeave: (_) {
        _dockController.updateHoveredIndex(null);
      },
      builder: (context, candidateData, rejectedData) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _dockController.updateHoveredIndex(widget.index),
          onExit: (_) => _dockController.updateHoveredIndex(null),
          child: Draggable<int>(
            data: widget.index,
            feedback: Obx(() => buildDockIcon(true)),
            childWhenDragging: const SizedBox.shrink(),
            onDragStarted: () =>
                _dockController.updateDraggedIndex(widget.index),
            onDragEnd: (_) {
              _dockController.updateDraggedIndex(null);
              _dockController.setDockHovered(false);
            },
            child: Obx(() => buildDockIcon(false)),
          ),
        );
      },
    );
  }

  /// Builds the representation of the dock icon.
  Widget buildDockIcon(bool isDragging) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _dockController.calculateScaledSize(widget.index),
      height:
          _dockController.calculateScaledSize(widget.index), // Adjust icon size
      margin: EdgeInsets.symmetric(
        horizontal: _dockController.spacing / 2,
      ),
      decoration: BoxDecoration(
        color: _dockController.items[widget.index].color,
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
        _dockController.items[widget.index].icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

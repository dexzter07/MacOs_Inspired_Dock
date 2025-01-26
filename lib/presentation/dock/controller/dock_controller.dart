import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/models/icons_model.dart';

/// The controller for managing dock interactions and state.
class DockController extends GetxController {
  /// The list of dock items.
  final items = <ItemModel>[
    ItemModel(icon: Icons.home, color: Colors.red),
    ItemModel(icon: Icons.message, color: Colors.blue),
    ItemModel(icon: Icons.camera, color: Colors.green),
    ItemModel(icon: Icons.phone, color: Colors.orange),
    ItemModel(icon: Icons.settings, color: Colors.purple),
  ].obs;

  /// The index of the hovered item.
  var hoveredIndex = Rxn<int>();

  /// The index of the dragged item.
  var draggedIndex = Rxn<int>();

  /// Checks the dock is currently being hoveredor not
  var isDockHovered = false.obs;

  /// The base size of dock icons.
  double baseSize = 50.0;

  /// The size of dock icons when hovered.
  double hoverSize = 60.0;

  /// The spacing between dock icons.
  double spacing = 10.0;

  /// The padding around the dock.
  double padding = 8.0;

  /// Updates the index of the currently hovered item.
  void updateHoveredIndex(int? index) {
    hoveredIndex.value = index;
  }

  /// Updates the index of the currently dragged item.
  void updateDraggedIndex(int? index) {
    draggedIndex.value = index;
  }

  /// Sets whether the dock is being hovered.
  void setDockHovered(bool value) {
    isDockHovered.value = value;
  }

  /// Reorders the items in the dock.
  void reorderItems(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  /// Calculates the total width of the dock.
  double calculateDockWidth() {
    return (items.length * baseSize) + ((items.length + 3) * spacing + padding);
  }

  /// Calculates the scaled size of an item based on its hover state.
  double calculateScaledSize(int index) {
    if (draggedIndex.value == index) return hoverSize;
    if (hoveredIndex.value == null) return baseSize;

    final distance = (hoveredIndex.value! - index).abs();
    if (distance == 0) return hoverSize;
    if (distance == 1) return hoverSize - 5;
    return baseSize;
  }
}

import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/models/icons_model.dart';

class DockController extends GetxController {
  final items = <ItemModel>[
    ItemModel(icon: Icons.home, color: Colors.red),
    ItemModel(icon: Icons.message, color: Colors.blue),
    ItemModel(icon: Icons.camera, color: Colors.green),
    ItemModel(icon: Icons.phone, color: Colors.orange),
    ItemModel(icon: Icons.settings, color: Colors.purple),
  ].obs;

  var hoveredIndex = Rxn<int>();
  var draggedIndex = Rxn<int>();
  var isDockHovered = false.obs;

  double baseSize = 50.0;
  double hoverSize = 60.0; // Adjusted size for hover effect
  double spacing = 10.0;
  double padding = 8.0;

  void updateHoveredIndex(int? index) {
    hoveredIndex.value = index;
  }

  void updateDraggedIndex(int? index) {
    draggedIndex.value = index;
  }

  void setDockHovered(bool value) {
    isDockHovered.value = value;
  }

  void reorderItems(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  double calculateDockWidth() {
    return (items.length * baseSize) + ((items.length + 3) * spacing + padding);
  }

  double calculateScaledSize(int index) {
    if (draggedIndex.value == index) return hoverSize;
    if (hoveredIndex.value == null) return baseSize;

    final distance = (hoveredIndex.value! - index).abs();
    if (distance == 0) return hoverSize;
    if (distance == 1) return hoverSize - 5;
    return baseSize;
  }
}

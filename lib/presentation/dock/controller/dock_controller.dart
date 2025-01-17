import 'package:dock_draggable/presentation/dock/models/icons_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DockController extends GetxController {
  final items = <ItemModel>[
    ItemModel(icon: Icons.person, color: Colors.red),
    ItemModel(icon: Icons.message, color: Colors.green),
    ItemModel(icon: Icons.call, color: Colors.blue),
    ItemModel(icon: Icons.camera, color: Colors.purple),
    ItemModel(icon: Icons.photo, color: Colors.orange),
  ].obs;

  var hoveredIndex = Rxn<int>();
  var draggedIndex = Rxn<int>();
  double baseItemHeight = 40;
  double baseTranslationY = 0.0;
  double verticalItemsPadding = 10;
  double maxHorizontalRepulsion = 40;

  void updateHoverIndex(int? index) {
    hoveredIndex.value = index;
  }

  void updateDraggedIndex(int? index) {
    draggedIndex.value = index;
  }

  void reorderItems(int oldIndex, int newIndex) {
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  double getScaledSize(int index) {
    if (draggedIndex.value != null && index == draggedIndex.value) {
      return 50; // Larger size for dragged item
    }

    if (hoveredIndex.value == null) {
      return baseItemHeight;
    }

    final distance = (hoveredIndex.value! - index).abs();
    if (distance == 0) {
      return 50; // Maximum size for hovered item
    } else if (distance == 1) {
      return 40; // Slightly scaled size for neighbors
    } else {
      return baseItemHeight; // Default size
    }
  }

  double getTranslationY(int index) {
    if (draggedIndex.value != null && index == draggedIndex.value) {
      return -30; // Lifted position for dragged item
    }

    if (hoveredIndex.value == null) {
      return baseTranslationY;
    }

    final distance = (hoveredIndex.value! - index).abs();
    if (distance == 0) {
      return -15; // Maximum hover translation
    } else if (distance == 1) {
      return -10; // Slightly reduced hover translation
    } else {
      return baseTranslationY; // Default translation
    }
  }

  double getTranslationX(int index) {
    if (draggedIndex.value == null || hoveredIndex.value == null) return 0.0;

    final distance = (hoveredIndex.value! - index).abs();
    final direction =
        (index - hoveredIndex.value!).sign; // Left (-1) or right (+1)

    if (distance == 1) {
      return direction * maxHorizontalRepulsion; // Repel nearby items
    } else if (distance == 2) {
      return direction *
          (maxHorizontalRepulsion / 2); // Smaller repulsion effect
    }
    return 0.0;
  }
}

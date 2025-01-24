import 'package:flutter/material.dart';

class MacOsInspiredDoc extends StatefulWidget {
  const MacOsInspiredDoc({super.key});

  @override
  State<MacOsInspiredDoc> createState() => _MacOsInspiredDocState();
}

class _MacOsInspiredDocState extends State<MacOsInspiredDoc> {
  late int? hoveredIndex;
  late double baseItemHeight;
  late double baseTranslationY;
  late double verticlItemsPadding;
  int? draggedIndex;
  late double maxHorizontalRepulsion;

  List<_Item> items = [
    _Item(icon: Icons.person, color: Colors.red),
    _Item(icon: Icons.message, color: Colors.green),
    _Item(icon: Icons.call, color: Colors.blue),
    _Item(icon: Icons.camera, color: Colors.purple),
    _Item(icon: Icons.photo, color: Colors.orange),
  ];

  double getScaledSize(int index) {
    if (draggedIndex != null && index == draggedIndex) {
      return 70; // Larger size for dragged item
    }

    if (hoveredIndex == null) {
      return baseItemHeight;
    }

    final distance = (hoveredIndex! - index).abs();
    if (distance == 0) {
      return 60; // Maximum size for the hovered item
    } else if (distance == 1) {
      return 50; // Slightly scaled size for neighbors
    } else {
      return baseItemHeight; // Default size
    }
  }

  double getTranslationY(int index) {
    if (draggedIndex != null && index == draggedIndex) {
      return -30; // Lifted position for dragged item
    }

    if (hoveredIndex == null) {
      return baseTranslationY;
    }

    final distance = (hoveredIndex! - index).abs();
    if (distance == 0) {
      return -15; // Maximum hover translation
    } else if (distance == 1) {
      return -10; // Slightly reduced hover translation
    } else {
      return baseTranslationY; // Default translation
    }
  }

  double getTranslationX(int index) {
    if (draggedIndex == null || hoveredIndex == null) return 0.0;

    final distance = (hoveredIndex! - index).abs();
    final direction =
        (index - hoveredIndex!).sign; // Determine left (-1) or right (+1)

    if (distance == 1) {
      return direction * maxHorizontalRepulsion; // Repel nearby items
    } else if (distance == 2) {
      return direction *
          (maxHorizontalRepulsion / 2); // Smaller repulsion effect
    }
    return 0.0;
  }

  @override
  void initState() {
    super.initState();
    hoveredIndex = null;
    baseItemHeight = 40;
    verticlItemsPadding = 10;
    baseTranslationY = 0.0;
    maxHorizontalRepulsion = 40;
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.black12,
          ),
          padding: EdgeInsets.all(verticlItemsPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              items.length,
              (index) {
                return DragTarget<int>(
                  onWillAcceptWithDetails: (draggedDetails) {
                    setState(() {
                      hoveredIndex = index; // Update hover effect
                    });
                    return true;
                  },
                  onAcceptWithDetails: (details) {
                    onReorder(details.data, index);
                  },
                  onLeave: (_) {
                    setState(() {
                      hoveredIndex = null; // Reset hover effect
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        if (draggedIndex == null) {
                          // Prevent hover effect during drag
                          setState(() {
                            hoveredIndex = index;
                          });
                        }
                      },
                      onExit: (_) {
                        if (draggedIndex == null) {
                          // Reset hover effect during drag
                          setState(() {
                            hoveredIndex = null;
                          });
                        }
                      },
                      child: Draggable<int>(
                        data: index,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildAnimatedItem(index, isDragging: true),
                        ),
                        onDragStarted: () {
                          setState(() {
                            draggedIndex = index;
                            hoveredIndex =
                                null; // Reset hover when dragging starts
                          });
                        },
                        onDragEnd: (_) {
                          setState(() {
                            draggedIndex =
                                null; // Clear dragged state when drag ends
                          });
                        },
                        childWhenDragging: Opacity(
                          opacity: 0.0,
                          child: _buildAnimatedItem(index),
                        ),
                        child: _buildAnimatedItem(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(int index, {bool isDragging = false}) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 48),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.identity()
        ..translate(
          getTranslationX(index),
          getTranslationY(index),
          0.0,
        ),
      height: getScaledSize(index),
      width: getScaledSize(index),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: items[index].color,
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
        items[index].icon,
        color: Colors.white,
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final Color color;

  _Item({required this.icon, required this.color});
}

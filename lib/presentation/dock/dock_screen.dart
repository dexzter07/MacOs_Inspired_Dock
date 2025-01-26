import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';
import 'package:dock_draggable/presentation/dock/widgets/draggable_icon_component.dart';

class MacOSDock extends StatelessWidget {
  /// The controller responsible for managing state.
  final DockController _dockController = Get.put(DockController());

  MacOSDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: MouseRegion(
          onEnter: (_) {
            return _dockController.setDockHovered(true); // Trigger hover effect
          },
          onExit: (_) {
            return _dockController.setDockHovered(false); // Remove hover effect
          },
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _dockController.isDockHovered.value
                  ? _dockController.calculateDockWidth() + 20
                  : _dockController.calculateDockWidth(),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _dockController.items.length,
                  (index) => DockItem(index: index), // Generates dock items
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

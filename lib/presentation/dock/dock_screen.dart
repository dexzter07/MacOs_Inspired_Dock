import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';
import 'package:dock_draggable/presentation/dock/widgets/draggable_icon_component.dart';

class MacOSDock extends StatelessWidget {
  final DockController controller = Get.put(DockController());

  MacOSDock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: MouseRegion(
          onEnter: (_) => controller.setDockHovered(true),
          onExit: (_) => controller.setDockHovered(false),
          child: Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controller.isDockHovered.value
                  ? controller.calculateDockWidth() + 20
                  : controller.calculateDockWidth(),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.items.length,
                  (index) => DockItem(index: index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

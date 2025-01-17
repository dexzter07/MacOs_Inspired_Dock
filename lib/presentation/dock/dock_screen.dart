import 'package:dock_draggable/presentation/dock/controller/dock_controller.dart';
import 'package:dock_draggable/presentation/dock/widgets/draggable_icon_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MacOsInspiredDoc extends StatelessWidget {
  final DockController controller = Get.put(DockController());

  MacOsInspiredDoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
      ),
      body: Center(
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.black12,
          ),
          padding: EdgeInsets.all(controller.verticalItemsPadding),
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(controller.items.length, (index) {
                return DockItem(index: index);
              }),
            ),
          ),
        ),
      ),
    );
  }
}

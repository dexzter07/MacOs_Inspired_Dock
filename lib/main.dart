import 'package:dock_draggable/core/imports.dart';
import 'package:dock_draggable/presentation/dock/dock_screen.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: MacOSDock());
  }
}

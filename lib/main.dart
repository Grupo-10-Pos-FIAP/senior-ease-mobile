import 'package:flutter/material.dart';
import 'package:senior_ease/app/app.dart';
import 'package:senior_ease/app/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MainApp());
}

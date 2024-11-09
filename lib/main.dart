import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spartapp_test/core/app.dart';

Future<void> main() async {
  await dotenv.load(fileName: "keys.env");
  runApp(const App());
}

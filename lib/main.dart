import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spartapp_test/core/app.dart';
import 'package:spartapp_test/features/gallery/data/models/gallery_item_local_image_model.dart';
import 'package:spartapp_test/features/gallery/data/models/gallery_item_local_model.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GalleryItemLocalImageModelAdapter());
  Hive.registerAdapter(GalleryItemLocalModelAdapter());
  await dotenv.load(fileName: "keys.env");
  runApp(const App());
}

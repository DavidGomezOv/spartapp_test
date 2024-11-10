import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spartapp_test/core/app.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_image_model.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_model.dart';
import 'package:spartapp_test/data/models/search_history/search_history_item_local_model.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GalleryItemLocalImageModelAdapter());
  Hive.registerAdapter(GalleryItemLocalModelAdapter());
  Hive.registerAdapter(SearchHistoryItemLocalModelAdapter());
  await dotenv.load(fileName: "keys.env");
  runApp(const App());
}

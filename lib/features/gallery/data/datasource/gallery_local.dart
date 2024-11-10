import 'package:spartapp_test/features/gallery/data/models/gallery_item_local_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GalleryLocal {
  final String _boxName = "favoriteImagesBox";

  Future<Box<GalleryItemLocalModel>> get _box async =>
      await Hive.openBox<GalleryItemLocalModel>(_boxName);

  Future<void> addFavorite({required GalleryItemLocalModel entityModel}) async {
    var box = await _box;
    await box.add(entityModel);
  }

  Future<List<GalleryItemLocalModel>> getAllFavorites() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteFavorite({required dynamic key}) async {
    var box = await _box;
    await box.delete(key);
  }
}

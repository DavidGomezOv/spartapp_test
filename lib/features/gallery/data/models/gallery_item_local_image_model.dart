import 'package:hive/hive.dart';

part 'gallery_item_local_image_model.g.dart';

@HiveType(typeId: 2)
class GalleryItemLocalImageModel extends HiveObject {
  @HiveField(0)
  final String link;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String type;

  GalleryItemLocalImageModel({
    required this.link,
    required this.description,
    required this.type,
  });
}

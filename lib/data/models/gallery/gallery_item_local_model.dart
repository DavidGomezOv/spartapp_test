import 'package:hive/hive.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_image_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

part 'gallery_item_local_model.g.dart';

@HiveType(typeId: 1)
class GalleryItemLocalModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final int datetime;
  @HiveField(4)
  final String accountUrl;
  @HiveField(5)
  final int views;
  @HiveField(6)
  final List<GalleryItemLocalImageModel> images;

  GalleryItemLocalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.datetime,
    required this.accountUrl,
    required this.views,
    required this.images,
  });

  factory GalleryItemLocalModel.fromDomainModel(GalleryItemModel domainModel) =>
      GalleryItemLocalModel(
        id: domainModel.id,
        title: domainModel.title,
        description: domainModel.description,
        datetime: domainModel.datetime,
        accountUrl: domainModel.accountUrl,
        views: domainModel.views,
        images: domainModel.images
            .map(
              (element) => GalleryItemLocalImageModel(
                link: element.link,
                description: element.description,
                type: element.type,
              ),
            )
            .toList(),
      );
}

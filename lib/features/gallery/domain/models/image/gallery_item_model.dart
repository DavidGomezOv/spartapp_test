import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_image_model.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_tag_model.dart';

part 'gallery_item_model.freezed.dart';

@freezed
class GalleryItemModel with _$GalleryItemModel {
  const factory GalleryItemModel({
    required String id,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int datetime,
    @Default('') String accountUrl,
    @Default(0) int views,
    @Default([]) List<GalleryItemImageModel> images,
    @Default([]) List<GalleryItemTagModel> tags,
  }) = _GalleryItemModel;

  factory GalleryItemModel.fromJsonModel(Map<String, dynamic> json) => GalleryItemModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        datetime: json['datetime'] ?? 0,
        accountUrl: json['account_url'] ?? '',
        views: json['views'] ?? '',
        images: json['images'] != null
            ? (json['images'] as List<dynamic>)
                .map(
                  (element) => GalleryItemImageModel.fromJson(element as Map<String, dynamic>),
                )
                .toList()
            : [],
        tags: json['tags'] != null
            ? (json['tags'] as List<dynamic>)
                .map(
                  (element) => GalleryItemTagModel.fromJsonModel(element as Map<String, dynamic>),
                )
                .toList()
            : [],
      );
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_item_image_model.freezed.dart';
part 'gallery_item_image_model.g.dart';

@freezed
class GalleryItemImageModel with _$GalleryItemImageModel {
  const factory GalleryItemImageModel({
    @Default('') String link,
    @Default('') String type,
  }) = _GalleryItemImageModel;

  factory GalleryItemImageModel.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemImageModelFromJson(json);
}

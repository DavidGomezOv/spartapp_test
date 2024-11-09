import 'package:freezed_annotation/freezed_annotation.dart';

part 'gallery_item_tag_model.freezed.dart';

@freezed
class GalleryItemTagModel with _$GalleryItemTagModel {
  const factory GalleryItemTagModel({
    @Default('') String displayName,
    @Default(0) int followers,
  }) = _GalleryItemTagModel;

  factory GalleryItemTagModel.fromJsonModel(Map<String, dynamic> json) => GalleryItemTagModel(
        displayName: json['display_name'] ?? '',
        followers: json['followers'] ?? 0,
      );
}

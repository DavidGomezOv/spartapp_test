import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_comment_model.freezed.dart';

part 'image_comment_model.g.dart';

@freezed
class ImageCommentModel with _$ImageCommentModel {
  const factory ImageCommentModel({
    @Default('') String author,
    @Default('') String comment,
    @Default(0) int datetime,
  }) = _ImageCommentModel;

  factory ImageCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ImageCommentModelFromJson(json);
}

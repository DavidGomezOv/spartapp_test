part of 'image_detail_cubit.dart';

enum ImageDetailFavoriteStatus { initial, loading, addedToFavorites, deletedFromFavorites, failed }

enum ImageCommentsStatus { initial, loading, loaded, failedToLoad }

@freezed
class ImageDetailState with _$ImageDetailState {
  const factory ImageDetailState({
    @Default(false) bool isImageInFavorites,
    GalleryItemModel? selectedImage,
    @Default([]) List<ImageCommentModel> imageComments,
    @Default(ImageDetailFavoriteStatus.initial) ImageDetailFavoriteStatus imageDetailStatus,
    @Default(ImageCommentsStatus.initial) ImageCommentsStatus imageCommentsStatus,
    String? errorMessage,
  }) = _ImageDetailState;
}

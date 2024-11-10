part of 'image_detail_cubit.dart';

enum ImageDetailFavoriteStatus { initial, loading, addedToFavorites, deletedFromFavorites, failed }

@freezed
class ImageDetailState with _$ImageDetailState {
  const factory ImageDetailState({
    @Default(false) bool isImageInFavorites,
    GalleryItemModel? selectedImage,
    @Default(ImageDetailFavoriteStatus.initial) ImageDetailFavoriteStatus imageDetailStatus,
    String? errorMessage,
  }) = _ImageDetailState;
}

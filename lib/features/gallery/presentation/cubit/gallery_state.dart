part of 'gallery_cubit.dart';

@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    @Default([]) List<GalleryItemModel> images,
    GalleryItemModel? selectedImage,
    @Default(0) int currentPage,
    String? searchCriteria,
    @Default(PageStatus.loading) PageStatus pageStatus,
    String? errorMessage,
  }) = _Loaded;
}

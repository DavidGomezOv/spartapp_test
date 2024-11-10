import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';

part 'image_detail_state.dart';

part 'image_detail_cubit.freezed.dart';

class ImageDetailCubit extends Cubit<ImageDetailState> {
  ImageDetailCubit({required this.favoritesRepository}) : super(const ImageDetailState());

  final FavoritesRepository favoritesRepository;

  Future<void> addImageToFavorites() async {
    if (state.selectedImage == null) return;

    emit(state.copyWith(imageDetailStatus: ImageDetailFavoriteStatus.loading));

    final result = await favoritesRepository.addFavorite(galleryItemModel: state.selectedImage!);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            imageDetailStatus: ImageDetailFavoriteStatus.addedToFavorites,
            isImageInFavorites: true,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            imageDetailStatus: ImageDetailFavoriteStatus.failed,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> deleteImageFromFavorites() async {
    if (state.selectedImage == null) return;

    emit(state.copyWith(imageDetailStatus: ImageDetailFavoriteStatus.loading));

    final result = await favoritesRepository.deleteFavorite(id: state.selectedImage!.id);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            imageDetailStatus: ImageDetailFavoriteStatus.deletedFromFavorites,
            isImageInFavorites: false,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            imageDetailStatus: ImageDetailFavoriteStatus.failed,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> updateSelectedImage({required GalleryItemModel selectedImage}) async {
    emit(state.copyWith(selectedImage: selectedImage));
    _checkImageInFavorites();
  }

  Future<void> _checkImageInFavorites() async {
    final result = await favoritesRepository.getFavorites();
    result.when(
      success: (images) {
        final data = images.firstWhereOrNull(
          (element) => element.id == state.selectedImage!.id,
        );
        emit(state.copyWith(isImageInFavorites: data != null));
      },
      failure: (error) => false,
    );
  }
}

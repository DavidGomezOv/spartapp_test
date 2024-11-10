import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/features/gallery/domain/repository/gallery_repository.dart';

part 'gallery_state.dart';

part 'gallery_cubit.freezed.dart';

class GalleryCubit extends Cubit<GalleryState> {
  GalleryCubit({required this.galleryRepository}) : super(const GalleryState());

  final GalleryRepository galleryRepository;

  Future<void> fetchGallery({int? page}) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final currentPage = page ?? state.currentPage + 1;

    final result = state.searchCriteria != null
        ? await galleryRepository.fetchGalleryBySearch(
            searchCriteria: state.searchCriteria!,
            page: currentPage,
          )
        : await galleryRepository.fetchGallery(page: currentPage);

    result.when(
      success: (data) {
        final List<GalleryItemModel> filteredList = [];
        for (final imageModel in data) {
          final imageOnlyFiles = imageModel.images
              .where(
                (element) => element.type.contains('image'),
              )
              .toList();
          if (imageOnlyFiles.isNotEmpty) {
            filteredList.add(imageModel.copyWith(images: imageOnlyFiles));
          }
        }

        emit(
          state.copyWith(
            pageStatus: PageStatus.loaded,
            images: [...state.images, ...filteredList],
            currentPage: currentPage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> getFavorites() async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await galleryRepository.getFavorites();

    result.when(
      success: (data) {
        emit(
          state.copyWith(pageStatus: PageStatus.loaded, images: data),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  void updateSelectedImage({required GalleryItemModel selectedImage}) {
    emit(state.copyWith(selectedImage: selectedImage));
  }

  void updateSearchCriteria({String? searchCriteria}) {
    emit(state.copyWith(searchCriteria: searchCriteria, images: []));
    fetchGallery(page: 1);
  }

  void updateShowFavorites() {
    emit(state.copyWith(showingFavorites: !state.showingFavorites, images: []));
    if (state.showingFavorites) {
      getFavorites();
    } else {
      fetchGallery(page: 1);
    }
  }
}

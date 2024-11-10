import 'package:collection/collection.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/gallery_local_source.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final GalleryLocalSource galleryLocalSource;

  FavoritesRepositoryImpl({required this.galleryLocalSource});

  @override
  Future<Result<bool>> addFavorite({required GalleryItemModel galleryItemModel}) {
    final entity = GalleryItemLocalModel.fromDomainModel(galleryItemModel);
    return galleryLocalSource
        .addFavorite(entityModel: entity)
        .then(
          (value) => const Result.success(data: true),
        )
        .onError(
          (error, stackTrace) => Result.failure(error: Exception(error.toString())),
        );
  }

  @override
  Future<Result<List<GalleryItemModel>>> getFavorites() async {
    return galleryLocalSource.getAllFavorites().then(
      (value) {
        final data = value
            .map(
              (element) => GalleryItemModel.fromEntity(element),
            )
            .toList();
        return Result.success(data: data);
      },
    ).onError(
      (error, stackTrace) => Result.failure(error: Exception(error.toString())),
    );
  }

  @override
  Future<Result<bool>> deleteFavorite({required String id}) async {
    final itemKey = await galleryLocalSource.getAllFavorites().then(
      (value) {
        final data = value.firstWhereOrNull(
          (element) => element.id == id,
        );
        return data?.key;
      },
    );
    return galleryLocalSource
        .deleteFavorite(key: itemKey)
        .then(
          (value) => const Result.success(data: true),
        )
        .onError(
          (error, stackTrace) => Result.failure(error: Exception(error.toString())),
        );
  }
}

import 'package:collection/collection.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/favorites_local_source.dart';
import 'package:spartapp_test/data/models/gallery/gallery_item_local_model.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalSource favoritesLocalSource;

  FavoritesRepositoryImpl({required this.favoritesLocalSource});

  @override
  Future<Result<bool>> addFavorite({required GalleryItemModel galleryItemModel}) async {
    try {
      final entity = GalleryItemLocalModel.fromDomainModel(galleryItemModel);
      return favoritesLocalSource.addFavorite(entityModel: entity).then(
            (value) => const Result.success(data: true),
          );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }

  @override
  Future<Result<List<GalleryItemModel>>> getFavorites() async {
    try {
      return favoritesLocalSource.getAllFavorites().then(
        (value) {
          final data = value
              .map(
                (element) => GalleryItemModel.fromEntity(element),
              )
              .toList();
          return Result.success(data: data);
        },
      );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteFavorite({required String id}) async {
    try {
      final itemKey = await favoritesLocalSource.getAllFavorites().then(
        (value) {
          final data = value.firstWhereOrNull(
            (element) => element.id == id,
          );
          return data?.key;
        },
      );
      return favoritesLocalSource.deleteFavorite(key: itemKey).then(
            (value) => const Result.success(data: true),
          );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }
}

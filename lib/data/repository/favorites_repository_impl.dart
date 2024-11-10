import 'package:collection/collection.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/gallery_local.dart';
import 'package:spartapp_test/data/models/gallery_item_local_image_model.dart';
import 'package:spartapp_test/data/models/gallery_item_local_model.dart';
import 'package:spartapp_test/domain/models/image/gallery_item_image_model.dart';
import 'package:spartapp_test/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final GalleryLocal galleryLocal;

  FavoritesRepositoryImpl({required this.galleryLocal});

  @override
  Future<Result<bool>> addFavorite({required GalleryItemModel galleryItemModel}) {
    final entity = GalleryItemLocalModel(
      id: galleryItemModel.id,
      title: galleryItemModel.title,
      description: galleryItemModel.description,
      datetime: galleryItemModel.datetime,
      accountUrl: galleryItemModel.accountUrl,
      views: galleryItemModel.views,
      images: galleryItemModel.images
          .map(
            (element) => GalleryItemLocalImageModel(
              link: element.link,
              description: element.description,
              type: element.type,
            ),
          )
          .toList(),
    );
    return galleryLocal
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
    return galleryLocal.getAllFavorites().then(
      (value) {
        final data = value
            .map(
              (element) => GalleryItemModel(
                id: element.id,
                title: element.title,
                description: element.description,
                datetime: element.datetime,
                accountUrl: element.accountUrl,
                views: element.views,
                images: element.images
                    .map(
                      (element) => GalleryItemImageModel(
                        link: element.link,
                        description: element.description,
                        type: element.type,
                      ),
                    )
                    .toList(),
              ),
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
    final itemKey = await galleryLocal.getAllFavorites().then(
      (value) {
        final data = value.firstWhereOrNull(
          (element) => element.id == id,
        );
        return data?.key;
      },
    );
    return galleryLocal
        .deleteFavorite(key: itemKey)
        .then(
          (value) => const Result.success(data: true),
        )
        .onError(
          (error, stackTrace) => Result.failure(error: Exception(error.toString())),
        );
  }
}

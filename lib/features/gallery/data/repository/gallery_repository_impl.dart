import 'package:collection/collection.dart';
import 'package:spartapp_test/core/exceptions.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/features/gallery/data/datasource/gallery_api.dart';
import 'package:spartapp_test/features/gallery/data/datasource/gallery_local.dart';
import 'package:spartapp_test/features/gallery/data/models/gallery_item_local_image_model.dart';
import 'package:spartapp_test/features/gallery/data/models/gallery_item_local_model.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_image_model.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/features/gallery/domain/repository/gallery_repository.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryApi galleryApi;
  final GalleryLocal galleryLocal;

  GalleryRepositoryImpl({
    required this.galleryApi,
    required this.galleryLocal,
  });

  @override
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page}) =>
      _captureErrorsOnApiCall(
        apiCall: galleryApi.fetchGallery(page: page),
      );

  @override
  Future<Result<List<GalleryItemModel>>> fetchGalleryBySearch({
    required String searchCriteria,
    required int page,
  }) {
    return _captureErrorsOnApiCall(
      apiCall: galleryApi.fetchGalleryBySearch(
        searchCriteria: searchCriteria,
        page: page,
      ),
    );
  }

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

  Future<Result<T>> _captureErrorsOnApiCall<T>({required Future<T> apiCall}) async {
    try {
      final result = await apiCall;
      return Result.success(data: result);
    } on NetworkException catch (error) {
      return Result.failure(error: error);
    } on Exception catch (error) {
      return Result.failure(error: error);
    }
  }
}

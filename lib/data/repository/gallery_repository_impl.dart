import 'package:spartapp_test/core/api_error_handler.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/gallery_api.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';
import 'package:spartapp_test/domain/repository/gallery_repository.dart';

class GalleryRepositoryImpl with ApiErrorHandler implements GalleryRepository {
  final GalleryApi galleryApi;

  GalleryRepositoryImpl({
    required this.galleryApi,
  });

  @override
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page}) =>
      captureErrorsOnApiCall(
        apiCall: () async {
          final result = await galleryApi.fetchGallery(page: page);

          return Result.success(data: result);
        },
      );

  @override
  Future<Result<List<GalleryItemModel>>> fetchGalleryBySearch({
    required String searchCriteria,
    required int page,
  }) =>
      captureErrorsOnApiCall(
        apiCall: () async {
          final result = await galleryApi.fetchGalleryBySearch(
            searchCriteria: searchCriteria,
            page: page,
          );

          return Result.success(data: result);
        },
      );
}

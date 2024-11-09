import 'package:spartapp_test/core/exceptions.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/features/gallery/data/datasource/gallery_api.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';
import 'package:spartapp_test/features/gallery/domain/repository/gallery_repository.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryApi galleryApi;

  GalleryRepositoryImpl({required this.galleryApi});

  @override
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page}) => _captureErrorsOnApiCall(
        apiCall: galleryApi.fetchGallery(page: page),
      );

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

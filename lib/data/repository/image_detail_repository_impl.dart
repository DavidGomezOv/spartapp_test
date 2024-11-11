import 'package:spartapp_test/core/api_error_handler.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/image_detail_api.dart';
import 'package:spartapp_test/domain/models/image_detail/image_comment_model.dart';
import 'package:spartapp_test/domain/repository/image_detail_repository.dart';

class ImageDetailRepositoryImpl with ApiErrorHandler implements ImageDetailRepository {
  final ImageDetailApi imageDetailApi;

  ImageDetailRepositoryImpl({required this.imageDetailApi});

  @override
  Future<Result<List<ImageCommentModel>>> fetchImageComments({
    required String imageId,
  }) =>
      captureErrorsOnApiCall(
        apiCall: () async {
          final result = await imageDetailApi.fetchImageComments(imageId: imageId);

          return Result.success(data: result);
        },
      );
}

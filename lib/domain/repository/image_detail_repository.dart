import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/image_detail/image_comment_model.dart';

abstract class ImageDetailRepository {
  Future<Result<List<ImageCommentModel>>> fetchImageComments({required String imageId});
}

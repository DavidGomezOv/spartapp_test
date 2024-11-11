import 'package:spartapp_test/core/base_datasource/base_api/base_api_client.dart';
import 'package:spartapp_test/core/base_datasource/base_json_parser/list_json_parser.dart';
import 'package:spartapp_test/domain/models/image_detail/image_comment_model.dart';

class ImageDetailApi {
  final BaseApiClient baseApiClient;

  ImageDetailApi({required this.baseApiClient});

  Future<List<ImageCommentModel>> fetchImageComments({required String imageId}) async =>
      await baseApiClient.invokeGet<List<ImageCommentModel>>(
        path: '/3/gallery/$imageId/comments',
        jsonParser: ListJsonParser<ImageCommentModel>(
          fromJson: ImageCommentModel.fromJson,
          jsonKeyName: 'data',
        ),
      );
}

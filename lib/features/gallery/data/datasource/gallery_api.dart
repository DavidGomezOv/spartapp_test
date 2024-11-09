import 'package:spartapp_test/core/base_datasource/base_api/base_api_client.dart';
import 'package:spartapp_test/core/base_datasource/base_json_parser/list_json_parser.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';

class GalleryApi {
  final BaseApiClient baseApiClient;

  GalleryApi({required this.baseApiClient});

  Future<List<GalleryItemModel>> fetchGallery({required int page}) async {
    final url = Uri.https(
      'api.imgur.com',
      '/3/gallery/hot/viral/$page',
    );

    return await baseApiClient.invokeGet<List<GalleryItemModel>>(
      path: url,
      jsonParser: ListJsonParser<GalleryItemModel>(
        fromJson: GalleryItemModel.fromJsonModel,
        jsonKeyName: 'data',
      ),
    );
  }
}

import 'package:spartapp_test/core/base_datasource/base_api/base_api_client.dart';
import 'package:spartapp_test/core/base_datasource/base_json_parser/list_json_parser.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

class GalleryApi {
  final BaseApiClient baseApiClient;

  GalleryApi({required this.baseApiClient});

  Future<List<GalleryItemModel>> fetchGallery({required int page}) async =>
      await baseApiClient.invokeGet<List<GalleryItemModel>>(
        path: '/3/gallery/hot/viral/$page',
        jsonParser: ListJsonParser<GalleryItemModel>(
          fromJson: GalleryItemModel.fromJsonModel,
          jsonKeyName: 'data',
        ),
      );

  Future<List<GalleryItemModel>> fetchGalleryBySearch({
    required String searchCriteria,
    required int page,
  }) async =>
      await baseApiClient.invokeGet<List<GalleryItemModel>>(
        path: '/3/gallery/search/viral/$page',
        queryParams: {'q': searchCriteria},
        jsonParser: ListJsonParser<GalleryItemModel>(
          fromJson: GalleryItemModel.fromJsonModel,
          jsonKeyName: 'data',
        ),
      );
}

import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

abstract class GalleryRepository {
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page});

  Future<Result<List<GalleryItemModel>>> fetchGalleryBySearch({
    required String searchCriteria,
    required int page,
  });
}

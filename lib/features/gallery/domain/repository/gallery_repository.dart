import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';

abstract class GalleryRepository {
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page});
}

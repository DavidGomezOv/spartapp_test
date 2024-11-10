import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/features/gallery/domain/models/image/gallery_item_model.dart';

abstract class GalleryRepository {
  Future<Result<List<GalleryItemModel>>> fetchGallery({required int page});

  Future<Result<List<GalleryItemModel>>> fetchGalleryBySearch({
    required String searchCriteria,
    required int page,
  });

  Future<Result<bool>> addFavorite({required GalleryItemModel galleryItemModel});

  Future<Result<List<GalleryItemModel>>> getFavorites();

  Future<Result<bool>> deleteFavorite({required String id});
}

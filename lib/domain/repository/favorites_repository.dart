import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/image/gallery_item_model.dart';

abstract class FavoritesRepository {

  Future<Result<bool>> addFavorite({required GalleryItemModel galleryItemModel});

  Future<Result<List<GalleryItemModel>>> getFavorites();

  Future<Result<bool>> deleteFavorite({required String id});

}
import 'package:mocktail/mocktail.dart';
import 'package:spartapp_test/domain/repository/favorites_repository.dart';
import 'package:spartapp_test/domain/repository/gallery_repository.dart';
import 'package:spartapp_test/domain/repository/search_history_repository.dart';

class MockGalleryRepository extends Mock implements GalleryRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockSearchHistoryRepository extends Mock implements SearchHistoryRepository {}

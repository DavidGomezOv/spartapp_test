import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/favorites_local_source.dart';
import 'package:spartapp_test/data/repository/favorites_repository_impl.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

import '../../mock_data.dart';
import 'favorites_repository_test.mocks.dart';

void _verifyListData({
  required List<GalleryItemModel> responseList,
  required List<GalleryItemModel> mockedList,
}) {
  expect(responseList.length, mockedList.length);
  mockedList.forEachIndexed(
    (index, element) {
      expect(responseList[index].id, element.id);
      expect(responseList[index].title, element.title);
      expect(responseList[index].description, element.description);
      expect(responseList[index].datetime, element.datetime);
      expect(responseList[index].accountUrl, element.accountUrl);
      expect(responseList[index].views, element.views);
      expect(responseList[index].images, element.images);
    },
  );
}

@GenerateNiceMocks([MockSpec<FavoritesLocalSource>()])
void main() {
  final MockFavoritesLocalSource mockFavoritesLocalSource = MockFavoritesLocalSource();
  late FavoritesRepositoryImpl favoritesRepositoryImpl;

  setUp(() {
    favoritesRepositoryImpl = FavoritesRepositoryImpl(
      favoritesLocalSource: mockFavoritesLocalSource,
    );
  });

  tearDown(() {
    clearInteractions(mockFavoritesLocalSource);
  });

  group('FavoriteRepository - getAllFavorites', () {
    test('Given a successfully API response should return Success with GalleryItemModel list',
        () async {
      when(mockFavoritesLocalSource.getAllFavorites()).thenAnswer(
        (_) async => mockedFavoritesList,
      );

      final result = await favoritesRepositoryImpl.getFavorites();

      verify(mockFavoritesLocalSource.getAllFavorites()).called(1);

      result.when(
        success: (data) => _verifyListData(responseList: data, mockedList: mockedGalleryList),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockFavoritesLocalSource.getAllFavorites()).thenThrow(badRequestError);

      final result = await favoritesRepositoryImpl.getFavorites();

      verify(mockFavoritesLocalSource.getAllFavorites()).called(1);

      result.when(
        success: (data) => expect(true, false, reason: 'Should have failed'),
        failure: (error) => expect(
          error,
          isInstanceOf<Exception>(),
          reason: 'Should have failed with Exception',
        ),
      );
    });
  });

  group('FavoriteRepository - addFavorite', () {
    test('Given a successfully Hive response should return Success with True value', () async {
      when(mockFavoritesLocalSource.addFavorite(entityModel: captureAnyNamed('entityModel')))
          .thenAnswer(
        (_) async => const Result.success(data: true),
      );

      final result =
          await favoritesRepositoryImpl.addFavorite(galleryItemModel: mockedGalleryItemModel);

      verify(mockFavoritesLocalSource.addFavorite(entityModel: captureAnyNamed('entityModel')))
          .called(1);

      result.when(
        success: (data) => expect(data, true, reason: 'Should have succeeded with True'),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully Hive response should return Failure', () async {
      when(mockFavoritesLocalSource.addFavorite(entityModel: captureAnyNamed('entityModel')))
          .thenThrow(badRequestError);

      final result =
          await favoritesRepositoryImpl.addFavorite(galleryItemModel: mockedGalleryItemModel);

      verify(mockFavoritesLocalSource.addFavorite(entityModel: captureAnyNamed('entityModel')))
          .called(1);

      result.when(
        success: (data) => expect(true, false, reason: 'Should have failed'),
        failure: (error) => expect(
          error,
          isInstanceOf<Exception>(),
          reason: 'Should have failed with Exception',
        ),
      );
    });
  });

  group('FavoriteRepository - deleteFavorite', () {
    test('Given a successfully Hive response should return Success with True value', () async {
      when(mockFavoritesLocalSource.getAllFavorites()).thenAnswer(
        (_) async => mockedFavoritesList,
      );
      when(mockFavoritesLocalSource.deleteFavorite(key: captureAnyNamed('key'))).thenAnswer(
        (_) async => const Result.success(data: true),
      );

      final result = await favoritesRepositoryImpl.deleteFavorite(id: '1');

      verify(mockFavoritesLocalSource.deleteFavorite(key: captureAnyNamed('key'))).called(1);

      result.when(
        success: (data) => expect(data, true, reason: 'Should have succeeded with True'),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockFavoritesLocalSource.getAllFavorites()).thenAnswer(
        (_) async => mockedFavoritesList,
      );
      when(mockFavoritesLocalSource.deleteFavorite(key: captureAnyNamed('key')))
          .thenThrow(badRequestError);

      final result = await favoritesRepositoryImpl.deleteFavorite(id: '1');

      verify(mockFavoritesLocalSource.deleteFavorite(key: captureAnyNamed('key'))).called(1);

      result.when(
        success: (data) => expect(true, false, reason: 'Should have failed'),
        failure: (error) => expect(
          error,
          isInstanceOf<Exception>(),
          reason: 'Should have failed with Exception',
        ),
      );
    });
  });
}

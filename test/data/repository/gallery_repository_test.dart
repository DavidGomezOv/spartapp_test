import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spartapp_test/core/exceptions.dart';
import 'package:spartapp_test/data/datasource/gallery_api.dart';
import 'package:spartapp_test/data/repository/gallery_repository_impl.dart';
import 'package:spartapp_test/domain/models/gallery/gallery_item_model.dart';

import '../../mock_data.dart';
import 'gallery_repository_test.mocks.dart';

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
      expect(responseList[index].tags, element.tags);
    },
  );
}

@GenerateNiceMocks([MockSpec<GalleryApi>()])
void main() {
  final MockGalleryApi mockGalleryApi = MockGalleryApi();

  late GalleryRepositoryImpl galleryRepositoryImpl;

  setUp(() {
    galleryRepositoryImpl = GalleryRepositoryImpl(galleryApi: mockGalleryApi);
  });

  tearDown(() {
    clearInteractions(mockGalleryApi);
  });

  final badRequestError = Exception('Something happened on the server');
  const page = 1;

  group('GalleryRepository - fetchGallery', () {
    test('Given a successfully API response should return Success with GalleryItemModel list',
        () async {
      when(mockGalleryApi.fetchGallery(page: page)).thenAnswer(
        (_) async => mockedGalleryList,
      );

      final result = await galleryRepositoryImpl.fetchGallery(page: page);

      verify(mockGalleryApi.fetchGallery(page: page)).called(1);

      result.when(
        success: (data) => _verifyListData(responseList: data, mockedList: mockedGalleryList),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockGalleryApi.fetchGallery(page: page)).thenThrow(badRequestError);

      final result = await galleryRepositoryImpl.fetchGallery(page: page);

      verify(mockGalleryApi.fetchGallery(page: page)).called(1);

      result.when(
        success: (data) => expect(true, false, reason: 'Should have failed'),
        failure: (error) => expect(
          error,
          isInstanceOf<Exception>(),
          reason: 'Should fail with Exception',
        ),
      );
    });
  });

  group('GalleryRepository - fetchGallery', () {
    const searchCriteria = 'movies';

    test('Given a successfully API response should return Success with GalleryItemModel list',
        () async {
      when(mockGalleryApi.fetchGalleryBySearch(searchCriteria: searchCriteria, page: page))
          .thenAnswer(
        (_) async => mockedGalleryList,
      );

      final result = await galleryRepositoryImpl.fetchGalleryBySearch(
        searchCriteria: searchCriteria,
        page: page,
      );

      verify(mockGalleryApi.fetchGalleryBySearch(searchCriteria: searchCriteria, page: page))
          .called(1);

      result.when(
        success: (data) => _verifyListData(responseList: data, mockedList: mockedGalleryList),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockGalleryApi.fetchGalleryBySearch(searchCriteria: searchCriteria, page: page))
          .thenThrow(badRequestError);

      final result = await galleryRepositoryImpl.fetchGalleryBySearch(
        searchCriteria: searchCriteria,
        page: page,
      );

      verify(mockGalleryApi.fetchGalleryBySearch(searchCriteria: searchCriteria, page: page))
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
}

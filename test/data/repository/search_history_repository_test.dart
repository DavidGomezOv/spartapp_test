import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/search_history_local_source.dart';
import 'package:spartapp_test/data/repository/search_history_repository_impl.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';

import '../../mock_data.dart';
import 'search_history_repository_test.mocks.dart';

void _verifyListData({
  required List<SearchHistoryItemModel> responseList,
  required List<SearchHistoryItemModel> mockedList,
}) {
  expect(responseList.length, mockedList.length);
  mockedList.forEachIndexed(
    (index, element) {
      expect(responseList[index].searchCriteria, element.searchCriteria);
    },
  );
}

@GenerateNiceMocks([MockSpec<SearchHistoryLocalSource>()])
void main() {
  final MockSearchHistoryLocalSource mockSearchHistoryLocalSource = MockSearchHistoryLocalSource();
  late SearchHistoryRepositoryImpl searchHistoryRepositoryImpl;

  setUp(() {
    searchHistoryRepositoryImpl = SearchHistoryRepositoryImpl(
      searchHistoryLocalSource: mockSearchHistoryLocalSource,
    );
  });

  tearDown(() {
    clearInteractions(mockSearchHistoryLocalSource);
  });

  final badRequestError = Exception('Something happened on the Hive database');

  group('SearchHistoryRepository - getSearchHistory', () {
    test('Given a successfully API response should return Success with SearchHistoryItemModel list',
        () async {
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenAnswer(
        (_) async => mockedSearchHistoryModelList,
      );

      final result = await searchHistoryRepositoryImpl.getSearchHistory();

      verify(mockSearchHistoryLocalSource.getSearchHistory()).called(1);

      result.when(
        success: (data) => _verifyListData(responseList: data, mockedList: mockedSearchHistoryList),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenThrow(badRequestError);

      final result = await searchHistoryRepositoryImpl.getSearchHistory();

      verify(mockSearchHistoryLocalSource.getSearchHistory()).called(1);

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

  group('SearchHistoryRepository - addSearchHistoryItem', () {
    test('Given a successfully Hive response should return Success with True value', () async {
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenAnswer(
        (_) async => mockedSearchHistoryModelList,
      );
      when(
        mockSearchHistoryLocalSource.addSearchHistoryItem(
          entityModel: captureAnyNamed('entityModel'),
        ),
      ).thenAnswer(
        (_) async => const Result.success(data: true),
      );

      final result = await searchHistoryRepositoryImpl.addSearchHistoryItem(
        searchHistoryItemModel: mockedSearchHistoryItemModel,
      );

      verify(
        mockSearchHistoryLocalSource.addSearchHistoryItem(
          entityModel: captureAnyNamed('entityModel'),
        ),
      ).called(1);

      result.when(
        success: (data) => expect(data, true, reason: 'Should have succeeded with True'),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully Hive response should return Failure', () async {
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenAnswer(
        (_) async => mockedSearchHistoryModelList,
      );
      when(
        mockSearchHistoryLocalSource.addSearchHistoryItem(
          entityModel: captureAnyNamed('entityModel'),
        ),
      ).thenThrow(badRequestError);

      final result = await searchHistoryRepositoryImpl.addSearchHistoryItem(
        searchHistoryItemModel: mockedSearchHistoryItemModel,
      );

      verify(
        mockSearchHistoryLocalSource.addSearchHistoryItem(
          entityModel: captureAnyNamed('entityModel'),
        ),
      ).called(1);

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
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenAnswer(
        (_) async => mockedSearchHistoryModelList,
      );
      when(mockSearchHistoryLocalSource.deleteSearchHistoryItem(key: captureAnyNamed('key')))
          .thenAnswer(
        (_) async => const Result.success(data: true),
      );

      final result = await searchHistoryRepositoryImpl.deleteSearchHistoryItem(
        searchCriteria: 'searchCriteria',
      );

      verify(mockSearchHistoryLocalSource.deleteSearchHistoryItem(key: captureAnyNamed('key')))
          .called(1);

      result.when(
        success: (data) => expect(data, true, reason: 'Should have succeeded with True'),
        failure: (error) => expect(true, false, reason: 'Should have succeeded'),
      );
    });

    test('Given a unsuccessfully API response should return Failure', () async {
      when(mockSearchHistoryLocalSource.getSearchHistory()).thenAnswer(
        (_) async => mockedSearchHistoryModelList,
      );
      when(mockSearchHistoryLocalSource.deleteSearchHistoryItem(key: captureAnyNamed('key')))
          .thenThrow(badRequestError);

      final result = await searchHistoryRepositoryImpl.deleteSearchHistoryItem(
        searchCriteria: 'searchCriteria',
      );

      verify(mockSearchHistoryLocalSource.deleteSearchHistoryItem(key: captureAnyNamed('key')))
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

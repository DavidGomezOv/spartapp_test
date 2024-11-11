import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/presentation/gallery/cubit/search_history/search_history_cubit.dart';

import '../../../../mock_data.dart';
import '../../../../mock_repository_providers.dart';

void main() {
  late MockSearchHistoryRepository mockSearchHistoryRepository;
  late SearchHistoryCubit cubit;

  setUp(() {
    mockSearchHistoryRepository = MockSearchHistoryRepository();
    cubit = SearchHistoryCubit(searchHistoryRepository: mockSearchHistoryRepository);
  });

  tearDown(() {
    reset(mockSearchHistoryRepository);
  });

  blocTest<SearchHistoryCubit, SearchHistoryState>(
    'emit Loading state and default values when initialized',
    build: () => cubit,
    verify: (cubit) {
      expect(cubit.state, const SearchHistoryState());
    },
  );

  group('getSearchHistory', () {
    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit Loaded with SearchHistoryItemModel list when getSearchHistory method called',
      setUp: () {
        when(() => mockSearchHistoryRepository.getSearchHistory()).thenAnswer(
          (_) async => const Result.success(data: mockedSearchHistoryList),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.getSearchHistory(),
      verify: (cubit) {
        expect(
          cubit.state,
          const SearchHistoryState(
            searchHistoryList: mockedSearchHistoryList,
            pageStatus: PageStatus.loaded,
          ),
        );
      },
    );

    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit FailedToLoad and Error message when getSearchHistory method called and failed',
      setUp: () {
        when(() => mockSearchHistoryRepository.getSearchHistory()).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.getSearchHistory(),
      verify: (cubit) {
        expect(
          cubit.state,
          SearchHistoryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('addSearchHistoryItem', () {
    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit Loaded with SearchHistoryItemModel list when addSearchHistoryItem method called',
      setUp: () {
        when(
          () => mockSearchHistoryRepository.addSearchHistoryItem(
            searchHistoryItemModel: mockedSearchHistoryItemModel,
          ),
        ).thenAnswer(
          (_) async => const Result.success(data: true),
        );
      },
      build: () => cubit,
      act: (cubit) =>
          cubit.addSearchHistoryItem(searchCriteria: mockedSearchHistoryItemModel.searchCriteria),
      verify: (cubit) {
        expect(
          cubit.state,
          const SearchHistoryState(
            searchHistoryList: [mockedSearchHistoryItemModel],
            pageStatus: PageStatus.loaded,
          ),
        );
      },
    );

    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit FailedToLoad and Error message when addSearchHistoryItem method called and failed',
      setUp: () {
        when(
          () => mockSearchHistoryRepository.addSearchHistoryItem(
            searchHistoryItemModel: mockedSearchHistoryItemModel,
          ),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) =>
          cubit.addSearchHistoryItem(searchCriteria: mockedSearchHistoryItemModel.searchCriteria),
      verify: (cubit) {
        expect(
          cubit.state,
          SearchHistoryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });

  group('deleteSearchHistoryItem', () {
    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit Loaded with searchHistoryList empty list when deleteSearchHistoryItem method called',
      setUp: () {
        when(
          () => mockSearchHistoryRepository.deleteSearchHistoryItem(
            searchCriteria: mockedSearchHistoryItemModel.searchCriteria,
          ),
        ).thenAnswer(
          (_) async => const Result.success(data: true),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.deleteSearchHistoryItem(
        searchCriteria: mockedSearchHistoryItemModel.searchCriteria,
      ),
      verify: (cubit) {
        expect(
          cubit.state,
          const SearchHistoryState(
            searchHistoryList: [],
            pageStatus: PageStatus.loaded,
          ),
        );
      },
    );

    blocTest<SearchHistoryCubit, SearchHistoryState>(
      'emit FailedToLoad and Error message when deleteSearchHistoryItem method called and failed',
      setUp: () {
        when(
          () => mockSearchHistoryRepository.deleteSearchHistoryItem(
            searchCriteria: mockedSearchHistoryItemModel.searchCriteria,
          ),
        ).thenAnswer(
          (_) async => Result.failure(error: exception),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.deleteSearchHistoryItem(
        searchCriteria: mockedSearchHistoryItemModel.searchCriteria,
      ),
      verify: (cubit) {
        expect(
          cubit.state,
          SearchHistoryState(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: exception.toString(),
          ),
        );
      },
    );
  });
}

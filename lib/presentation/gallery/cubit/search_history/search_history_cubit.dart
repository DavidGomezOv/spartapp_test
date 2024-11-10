import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spartapp_test/core/enums.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';
import 'package:spartapp_test/domain/repository/search_history_repository.dart';

part 'search_history_state.dart';

part 'search_history_cubit.freezed.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  SearchHistoryCubit({
    required this.searchHistoryRepository,
  }) : super(const SearchHistoryState());

  final SearchHistoryRepository searchHistoryRepository;

  Future<void> getSearchHistory() async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await searchHistoryRepository.getSearchHistory();

    result.when(
      success: (data) {
        emit(
          state.copyWith(pageStatus: PageStatus.loaded, searchHistoryList: data),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> addSearchHistoryItem({required String searchCriteria}) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final model = SearchHistoryItemModel(searchCriteria: searchCriteria);

    final result = await searchHistoryRepository.addSearchHistoryItem(
      searchHistoryItemModel: SearchHistoryItemModel(searchCriteria: searchCriteria),
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.loaded,
            searchHistoryList: [
              if (data) model,
              ...state.searchHistoryList,
            ],
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> deleteSearchHistoryItem({required String searchCriteria}) async {
    emit(state.copyWith(pageStatus: PageStatus.loading));

    final result = await searchHistoryRepository.deleteSearchHistoryItem(
      searchCriteria: searchCriteria,
    );

    result.when(
      success: (data) {
        List<SearchHistoryItemModel> newList = List.from(state.searchHistoryList);
        newList.removeWhere(
          (element) => element.searchCriteria == searchCriteria,
        );
        emit(
          state.copyWith(
            pageStatus: PageStatus.loaded,
            searchHistoryList: newList,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            pageStatus: PageStatus.failedToLoad,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }
}

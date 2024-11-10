part of 'search_history_cubit.dart';

@freezed
class SearchHistoryState with _$SearchHistoryState {
  const factory SearchHistoryState({
    @Default([]) List<SearchHistoryItemModel> searchHistoryList,
    @Default(PageStatus.loading) PageStatus pageStatus,
    String? errorMessage,
  }) = _SearchHistoryState;
}

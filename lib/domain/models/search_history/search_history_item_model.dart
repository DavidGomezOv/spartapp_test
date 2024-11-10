import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spartapp_test/data/models/search_history/search_history_item_local_model.dart';

part 'search_history_item_model.freezed.dart';

@freezed
class SearchHistoryItemModel with _$SearchHistoryItemModel {
  const SearchHistoryItemModel._();

  const factory SearchHistoryItemModel({
    @Default('') String searchCriteria,
  }) = _SearchHistoryItemModel;

  factory SearchHistoryItemModel.fromEntity(SearchHistoryItemLocalModel entity) =>
      SearchHistoryItemModel(
        searchCriteria: entity.searchCriteria,
      );
}

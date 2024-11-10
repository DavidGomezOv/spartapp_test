import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';

abstract class SearchHistoryRepository {
  Future<Result<bool>> addSearchHistoryItem({required SearchHistoryItemModel searchHistoryItemModel});

  Future<Result<List<SearchHistoryItemModel>>> getSearchHistory();

  Future<Result<bool>> deleteSearchHistoryItem({required String searchCriteria});
}

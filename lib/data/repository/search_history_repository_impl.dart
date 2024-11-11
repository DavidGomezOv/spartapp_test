import 'package:collection/collection.dart';
import 'package:spartapp_test/core/result.dart';
import 'package:spartapp_test/data/datasource/search_history_local_source.dart';
import 'package:spartapp_test/data/models/search_history/search_history_item_local_model.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';
import 'package:spartapp_test/domain/repository/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final SearchHistoryLocalSource searchHistoryLocalSource;

  SearchHistoryRepositoryImpl({required this.searchHistoryLocalSource});

  @override
  Future<Result<bool>> addSearchHistoryItem({
    required SearchHistoryItemModel searchHistoryItemModel,
  }) async {
    try {
      final itemKey = await _getItemKey(searchCriteria: searchHistoryItemModel.searchCriteria);
      if (itemKey != null) return const Result.success(data: false);

      final entity = SearchHistoryItemLocalModel.fromDomainModel(searchHistoryItemModel);
      return searchHistoryLocalSource.addSearchHistoryItem(entityModel: entity).then(
            (value) => const Result.success(data: true),
          );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }

  @override
  Future<Result<List<SearchHistoryItemModel>>> getSearchHistory() async {
    try {
      return searchHistoryLocalSource.getSearchHistory().then(
        (value) {
          final data = value
              .map(
                (element) => SearchHistoryItemModel.fromEntity(element),
              )
              .toList();
          return Result.success(data: data);
        },
      );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteSearchHistoryItem({required String searchCriteria}) async {
    try {
      final itemKey = await _getItemKey(searchCriteria: searchCriteria);
      return searchHistoryLocalSource.deleteSearchHistoryItem(key: itemKey).then(
            (value) => const Result.success(data: true),
          );
    } catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }

  Future<dynamic> _getItemKey({required String searchCriteria}) async {
    return await searchHistoryLocalSource.getSearchHistory().then(
      (value) {
        final data = value.firstWhereOrNull(
          (element) => element.searchCriteria == searchCriteria,
        );
        return data?.key;
      },
    );
  }
}

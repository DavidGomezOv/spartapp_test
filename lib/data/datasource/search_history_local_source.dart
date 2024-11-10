import 'package:hive_flutter/hive_flutter.dart';
import 'package:spartapp_test/data/models/search_history/search_history_item_local_model.dart';

class SearchHistoryLocalSource {
  final String _boxName = "searchHistoryBox";

  Future<Box<SearchHistoryItemLocalModel>> get _box async =>
      await Hive.openBox<SearchHistoryItemLocalModel>(_boxName);

  Future<void> addSearchHistoryItem({required SearchHistoryItemLocalModel entityModel}) async {
    var box = await _box;
    await box.add(entityModel);
  }

  Future<List<SearchHistoryItemLocalModel>> getSearchHistory() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteSearchHistoryItem({required dynamic key}) async {
    var box = await _box;
    await box.delete(key);
  }
}

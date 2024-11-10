import 'package:hive/hive.dart';
import 'package:spartapp_test/domain/models/search_history/search_history_item_model.dart';

part 'search_history_item_local_model.g.dart';

@HiveType(typeId: 3)
class SearchHistoryItemLocalModel extends HiveObject {
  @HiveField(0)
  final String searchCriteria;

  SearchHistoryItemLocalModel({
    required this.searchCriteria,
  });

  factory SearchHistoryItemLocalModel.fromDomainModel(SearchHistoryItemModel domainModel) =>
      SearchHistoryItemLocalModel(
        searchCriteria: domainModel.searchCriteria,
      );
}

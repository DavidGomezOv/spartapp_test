import 'package:spartapp_test/core/base_datasource/base_json_parser/base_json_parser.dart';

abstract class BaseApiClient {
  Future<T> invokeGet<T>({
    required Uri path,
    Map<String, String>? headerParams,
    required BaseJsonParser<T> jsonParser,
  });
}

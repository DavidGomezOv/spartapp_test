import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:spartapp_test/core/base_datasource/base_api/base_api_client.dart';
import 'package:spartapp_test/core/base_datasource/base_json_parser/base_json_parser.dart';
import 'package:spartapp_test/core/exceptions.dart';

class ApiClient implements BaseApiClient {
  @override
  Future<T> invokeGet<T>({
    required String path,
    Map<String, String>? headerParams,
    required BaseJsonParser<T> jsonParser,
  }) async {
    final url = Uri.https(
      'api.imgur.com',
      path,
    );

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Client-ID ${dotenv.env['CLIENT_ID']}'},
      ).timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          return jsonParser.parseFromJson(response.body);
        default:
          throw ApiException(
            code: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } on TimeoutException catch (_) {
      throw NetworkException(message: 'Connection Timeout');
    } on http.ClientException catch (error) {
      throw Exception('Failed parsing json data: $error');
    }
  }
}

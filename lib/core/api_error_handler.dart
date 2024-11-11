import 'package:spartapp_test/core/exceptions.dart';
import 'package:spartapp_test/core/result.dart';

typedef GetApiResult<T> = Future<Result<T>> Function();

mixin ApiErrorHandler {

  Future<Result<T>> captureErrorsOnApiCall<T>({required GetApiResult<T> apiCall}) async {
    try {
      return await apiCall();
    } on NetworkException catch (error) {
      return Result.failure(error: error);
    } on Exception catch (error) {
      return Result.failure(error: error);
    } on Error catch (error) {
      return Result.failure(error: Exception(error.toString()));
    }
  }
}

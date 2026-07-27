import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_strings.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('${AppStrings.somethingWentWrong} ($e)');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppStrings.connectionTimeout;
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 404) {
          return AppStrings.noCharactersFoundCriteria;
        }
        return '${AppStrings.serverErrorPrefix}${error.response?.statusCode}${AppStrings.serverErrorSuffix}';
      case DioExceptionType.cancel:
        return AppStrings.requestCancelled;
      case DioExceptionType.connectionError:
        return AppStrings.noInternetConnection;
      default:
        return AppStrings.somethingWentWrong;
    }
  }
}

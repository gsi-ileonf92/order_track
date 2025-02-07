import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioClient {
  final Dio _dio;
  static const _timeOut = Duration(seconds: 30);

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Endpoints.baseUrl,
            connectTimeout: _timeOut,
            receiveTimeout: _timeOut,
          ),
        ) {
    _dio.interceptors.add(
      TalkerDioLogger(
        settings: TalkerDioLoggerSettings(
          enabled: kDebugMode,
          printRequestHeaders: true,
          requestPen: AnsiPen()..magenta(),
          responsePen: AnsiPen()..green(),
          errorPen: AnsiPen()..red(),
        ),
      ),
    );
  }

  //* Perform a GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //* Perform a POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //* Perform a PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //* Perform a DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //* Handle Dio errors
  String _handleError(DioException error) {
    String errorMessage = 'An unknown error occurred.';
    if (error.response != null) {
      errorMessage =
          error.response?.data?['message'] ?? error.message ?? errorMessage;
    } else {
      errorMessage = error.message ?? errorMessage;
    }
    return errorMessage;
  }
}

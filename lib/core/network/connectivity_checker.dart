import 'dart:io';
import 'package:dio/dio.dart';

/// Utility for checking network connectivity
///
/// Provides fast connectivity checks before making API requests
/// to give users immediate feedback instead of waiting for timeouts
class ConnectivityChecker {
  final Dio _dio;

  ConnectivityChecker(this._dio);

  /// Check if device has internet connectivity
  ///
  /// Returns true if a connection can be established to a reliable endpoint
  /// Uses a lightweight HEAD request with short timeout for fast checks
  Future<bool> hasConnectivity() async {
    try {
      // Try to reach a reliable endpoint with minimal data transfer
      final response = await _dio.head(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return response.statusCode != null && response.statusCode! < 500;
    } on DioException catch (e) {
      // Check if it's a connectivity issue vs server issue
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return false;
      }
      // If we got a response (even an error), we have connectivity
      return e.response != null;
    } on SocketException {
      return false;
    } catch (e) {
      // Unknown error, assume no connectivity to be safe
      return false;
    }
  }

  /// Check if we can reach a specific host
  ///
  /// Useful for checking if specific API endpoints are reachable
  Future<bool> canReachHost(String host) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/local_storage_service.dart';
import 'api_exceptions.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url, {bool enableCache = true}) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (enableCache) {
          await LocalStorageService.saveString('cache_$url', response.body);
        }
        return decoded;
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ServerException('Failed with status code: ${response.statusCode}');
      }
    } on SocketException {
      // Offline mode attempt to read from local disk cache
      if (enableCache) {
        final cached = await LocalStorageService.getString('cache_$url');
        if (cached != null && cached.isNotEmpty) {
          return jsonDecode(cached);
        }
      }
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      // If network fails, attempt cache
      if (enableCache) {
        final cached = await LocalStorageService.getString('cache_$url');
        if (cached != null && cached.isNotEmpty) {
          return jsonDecode(cached);
        }
      }
      throw ApiException('Unexpected network error: $e');
    }
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ServerException('POST failed with code ${response.statusCode}');
      }
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected request error: $e');
    }
  }
}

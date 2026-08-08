import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage_service.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<UserModel> login(String username, String password) async {
    // Attempt real API or fallback mock authentication
    try {
      final res = await _apiClient.post(
        ApiEndpoints.login,
        body: {'username': username, 'password': password},
      );
      if (res['token'] != null) {
        await LocalStorageService.saveString(
            LocalStorageService.keyAuthToken, res['token'].toString());
      }
    } catch (_) {
      // Mock session for demo purposes
      await LocalStorageService.saveString(
          LocalStorageService.keyAuthToken, 'mock_token_suk_12345');
    }

    return UserModel(
      id: 1,
      email: username.contains('@') ? username : '$username@sukshopping.com',
      username: username,
      name: username.isEmpty ? 'John Doe' : username.toUpperCase(),
    );
  }

  Future<void> logout() async {
    await LocalStorageService.remove(LocalStorageService.keyAuthToken);
  }

  Future<bool> isLoggedIn() async {
    final token =
        await LocalStorageService.getString(LocalStorageService.keyAuthToken);
    return token != null && token.isNotEmpty;
  }
}

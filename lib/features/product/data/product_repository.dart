import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/product.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get(ApiEndpoints.products);
    final list = response as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> getCategories() async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    final list = response as List<dynamic>;
    return list.map((e) => e.toString()).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response =
        await _apiClient.get(ApiEndpoints.category(category));
    final list = response as List<dynamic>;
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> getProductDetails(int id) async {
    final response = await _apiClient.get(ApiEndpoints.productDetails(id));
    return Product.fromJson(response as Map<String, dynamic>);
  }
}

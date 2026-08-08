class ApiEndpoints {
  static const String baseUrl = 'https://fakestoreapi.com';

  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/categories';
  static String category(String name) => '$baseUrl/products/category/$name';
  static String productDetails(int id) => '$baseUrl/products/$id';

  static const String carts = '$baseUrl/carts';
  static String userCarts(int userId) => '$baseUrl/carts/user/$userId';

  static const String login = '$baseUrl/auth/login';
  static const String users = '$baseUrl/users';
}

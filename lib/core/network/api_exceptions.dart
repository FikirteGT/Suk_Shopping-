class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No Internet Connection. Please check your network.'])
      : super(message);
}

class ServerException extends ApiException {
  ServerException([String message = 'Server Error occurred. Please try again later.'])
      : super(message, statusCode: 500);
}

class NotFoundException extends ApiException {
  NotFoundException([String message = 'Requested resource not found.'])
      : super(message, statusCode: 404);
}

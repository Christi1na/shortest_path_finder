import 'package:dio/dio.dart';

class ApiClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Uri buildApiUri(String input) {
    final uri = Uri.parse(input.trim());

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw const FormatException('URL must use HTTP or HTTPS');
    }

    if (uri.host.isEmpty) {
      throw const FormatException('Invalid URL');
    }

    final trimmedPath = uri.path.replaceFirst(
      RegExp(r'/+$'),
      '',
    );

    final path = trimmedPath.endsWith('/flutter/api')
        ? trimmedPath
        : '$trimmedPath/flutter/api';

    return uri.replace(
      path: path.isEmpty ? '/flutter/api' : path,
    );
  }
}
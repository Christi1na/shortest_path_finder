
class ApiResponseModel<T> {
  final bool error;
  final String message;
  final T data;

  const ApiResponseModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }
}
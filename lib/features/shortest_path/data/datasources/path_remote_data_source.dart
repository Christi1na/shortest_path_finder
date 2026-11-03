
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/api_response_model.dart';
import '../models/path_result_model.dart';
import '../models/path_task_model.dart';
import '../models/submission_result_model.dart';

abstract interface class PathRemoteDataSource {
  Future<List<PathTaskModel>> getTasks(String apiUrl);

  Future<List<SubmissionResultModel>> submitResults(
    String apiUrl,
    List<PathResultModel> results,
  );
}

class PathRemoteDataSourceImpl implements PathRemoteDataSource {
  final Dio dio;

  PathRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PathTaskModel>> getTasks(String apiUrl) async {
    final uri = ApiClient.buildApiUri(apiUrl);

    final response = await dio.getUri(uri);

    final apiResponse = ApiResponseModel<List<PathTaskModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map(
            (item) => PathTaskModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

    if (apiResponse.error) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data;
  }

  @override
  Future<List<SubmissionResultModel>> submitResults(
    String apiUrl,
    List<PathResultModel> results,
  ) async {
    final uri = ApiClient.buildApiUri(apiUrl);

    final response = await dio.postUri(
      uri,
      data: results.map((result) => result.toJson()).toList(),
    );

    final apiResponse =
        ApiResponseModel<List<SubmissionResultModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map(
            (item) => SubmissionResultModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

    if (apiResponse.error) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data;
  }
}
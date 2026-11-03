
import 'package:dio/dio.dart';

import '../models/api_response_model.dart';
import '../models/path_result_model.dart';
import '../models/path_task_model.dart';
import '../models/submission_result_model.dart';

abstract interface class PathRemoteDataSource {
  Future<List<PathTaskModel>> getTasks();

  Future<List<SubmissionResultModel>> submitResults(
    List<PathResultModel> results,
  );
}

class PathRemoteDataSourceImpl implements PathRemoteDataSource {
  final Dio dio;

  PathRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PathTaskModel>> getTasks() async {
    final response = await dio.get('/flutter/api');

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
    List<PathResultModel> results,
  ) async {
    final response = await dio.post(
      '/flutter/api',
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
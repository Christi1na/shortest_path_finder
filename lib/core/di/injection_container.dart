import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/api_client.dart';

import '../../features/shortest_path/data/datasources/path_remote_data_source.dart';
import '../../features/shortest_path/data/repositories/path_repository_impl.dart';

import '../../features/shortest_path/domain/algorithms/shortest_path_finder.dart';
import '../../features/shortest_path/domain/repositories/path_repository.dart';
import '../../features/shortest_path/domain/usecases/calculate_shortest_paths.dart';
import '../../features/shortest_path/domain/usecases/get_tasks.dart';
import '../../features/shortest_path/domain/usecases/submit_results.dart';

import '../../features/shortest_path/presentation/bloc/shortest_path_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() => ApiClient.create());

  sl.registerLazySingleton<PathRemoteDataSource>(
    () => PathRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PathRepository>(
    () => PathRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<ShortestPathFinder>(
    () => ShortestPathFinder(),
  );

  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => CalculateShortestPaths(sl()));
  sl.registerLazySingleton(() => SubmitResults(sl()));

  sl.registerFactory(
    () => ShortestPathBloc(
      getTasks: sl(),
      calculateShortestPaths: sl(),
      submitResults: sl(),
    ),
  );
}
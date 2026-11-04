import 'package:flutter/material.dart';
import 'package:shortest_path_finder/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_path_finder/core/router/route_generator.dart';
import 'package:shortest_path_finder/features/shortest_path/presentation/bloc/shortest_path_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShortestPathBloc>(),
      child: MaterialApp.router(
        title: 'Shortest Path Finder',
        routerConfig: appRouter,
      ),
    );
  }
}
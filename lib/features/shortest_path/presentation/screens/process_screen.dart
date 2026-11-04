import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/route_generator.dart';
import '../bloc/shortest_path_bloc.dart';
import '../widgets/animated_circular_progress.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  bool _progressCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Process screen',
      ),
      body: BlocConsumer<ShortestPathBloc, ShortestPathState>(
        listenWhen: (previous, current) =>
          current is ShortestPathLoading ||
          current is ShortestPathCalculating ||
          current is ShortestPathCompleted,
        listener: (context, state) {
          if (state is ShortestPathLoading ||
              (state is ShortestPathCalculating && state.progress == 0)) {
            setState(() {
              _progressCompleted = false;
            });
          }

          if (state is ShortestPathCompleted) {
            context.pushReplacement(
              AppRoutes.results,
              extra: ResultsRouteData(
                tasks: state.tasks,
                results: state.results,
                submissionResults: state.submissionResults,
              ),
            );
          }
        },
        builder: (context, state) {
          final isReady = state is ShortestPathReady;
          final isSubmitting = state is ShortestPathSubmitting;
      
          final errorState = state is ShortestPathError
              ? state
              : null;
      
          final canRetry = errorState != null &&
              errorState.apiUrl != null &&
              errorState.tasks != null &&
              errorState.results != null;
      
          final isError = errorState != null;
      
          final double progress;

          if (state is ShortestPathCalculating) {
            progress = state.progress;
          } else if (isReady || isSubmitting || canRetry) {
            progress = 1.0;
          } else {
            progress = 0.0;
          }
      
          final showButton =
              (isReady || canRetry || isSubmitting) && _progressCompleted;
      
          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                             mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isReady || isSubmitting)
                                const Text(
                                  'All calculations have finished, you can send your results to server',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                    
                              if (isError)
                                Text(
                                  errorState.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                                    
                              if (isReady || isError || isSubmitting)
                                const SizedBox(height: 20),
                                    
                              AnimatedCircularProgress(
                                progress: progress,
                                onCompleted: () {
                                  if (!_progressCompleted && mounted) {
                                    setState(() {
                                      _progressCompleted = true;
                                    });
                                  }
                                },
                              ),
                                            
                            ],
                          ),
                        ),
                      ),
                            
                      if (showButton)
                        CustomButton(
                          text: canRetry
                              ? 'Try again'
                              : 'Send results to server',
                          onTap: isSubmitting
                              ? null
                              : () {
                                  context.read<ShortestPathBloc>().add(
                                    SubmitPathResults(),
                                  );
                                },
                        ),
                    ],
                  ),
                ),
              ),
                    
              if (isSubmitting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
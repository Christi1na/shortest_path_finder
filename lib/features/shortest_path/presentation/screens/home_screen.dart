import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_routes.dart';
import '../bloc/shortest_path_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }

  Future<void> _loadSavedUrl() async {
    final preferences = await SharedPreferences.getInstance();
    final savedUrl = preferences.getString('api_url');

    if (!mounted) return;

    if (savedUrl != null) {
      _urlController.text = savedUrl;
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());

    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _start() async {
    final apiUrl = _urlController.text.trim();

    if (!_isValidUrl(apiUrl)) {
      setState(() {
        _errorMessage = 'Please enter a valid URL';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('api_url', apiUrl);

    if (!mounted) return;

    context.read<ShortestPathBloc>().add(
      StartCalculation(apiUrl),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home screen',
        showBackButton: false,
      ),
      body: BlocConsumer<ShortestPathBloc, ShortestPathState>(
        listenWhen: (previous, current) =>
            current is ShortestPathCalculating && current.progress == 0,
        listener: (context, state) {
          context.push(AppRoutes.process);
        },
        builder: (context, state) {
          final isLoadingTasks = state is ShortestPathLoading;
          final isDisabled = _isLoading || isLoadingTasks;

          final errorMessage = state is ShortestPathError
              ? state.message
              : _errorMessage;

          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Set valid API base URL in order to continue',
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(Icons.compare_arrows, color: Colors.grey,),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              enabled: !isDisabled,
                              keyboardType: TextInputType.url,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter URL',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                errorText: errorMessage,
                              ),
                              onChanged: (_) {
                                if (_errorMessage != null) {
                                  setState(() {
                                    _errorMessage = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const Expanded(child: SizedBox()),

                      CustomButton(
                        text: 'Start counting process',
                        onTap: isDisabled ? null : _start,
                      ),
                    ],
                  ),
                ),
              ),

              if (isLoadingTasks)
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
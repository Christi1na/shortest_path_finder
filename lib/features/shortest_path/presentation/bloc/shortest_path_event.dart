part of 'shortest_path_bloc.dart';

sealed class ShortestPathEvent extends Equatable {
  const ShortestPathEvent();

  @override
  List<Object> get props => [];
}

class StartCalculation extends ShortestPathEvent {
  final String apiUrl;

  const StartCalculation(this.apiUrl);
}

class SubmitPathResults extends ShortestPathEvent {}

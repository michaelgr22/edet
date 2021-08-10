part of 'standings_cubit.dart';

@immutable
abstract class StandingsState {
  const StandingsState();
}

class StandingsStateInitial extends StandingsState {
  const StandingsStateInitial();
}

class StandingsStateLoaded extends StandingsState {
  final List<StandingsRowModel> standings;
  const StandingsStateLoaded(this.standings);
}

class StandingsStateLoading extends StandingsState {
  const StandingsStateLoading();
}

class StandingsStateError extends StandingsState {
  final String message;
  const StandingsStateError(this.message);
}

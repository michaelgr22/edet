part of 'league_cubit.dart';

@immutable
abstract class LeagueState {
  const LeagueState();
}

class LeagueStateInitial extends LeagueState {
  const LeagueStateInitial();
}

class LeagueStateLoaded extends LeagueState {
  final LeagueModel league;
  const LeagueStateLoaded(this.league);
}

class LeagueStateLoading extends LeagueState {
  const LeagueStateLoading();
}

class LeagueStateError extends LeagueState {
  final String message;
  const LeagueStateError(this.message);
}

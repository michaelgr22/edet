part of 'leaguematches_cubit.dart';

@immutable
abstract class LeagueMatchesState {
  const LeagueMatchesState();
}

class LeagueMatchesStateInitial extends LeagueMatchesState {
  const LeagueMatchesStateInitial();
}

class LeagueMatchesStateLoaded extends LeagueMatchesState {
  final List<MatchModel> matches;
  const LeagueMatchesStateLoaded(this.matches);
}

class LeagueMatchesStateLoading extends LeagueMatchesState {
  const LeagueMatchesStateLoading();
}

class LeagueMatchesStateError extends LeagueMatchesState {
  final String message;
  const LeagueMatchesStateError(this.message);
}

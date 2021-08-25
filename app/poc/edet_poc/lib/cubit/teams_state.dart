part of 'teams_cubit.dart';

@immutable
abstract class TeamsState {
  const TeamsState();
}

class TeamsStateInitial extends TeamsState {
  const TeamsStateInitial();
}

class TeamsStateLoaded extends TeamsState {
  final LeagueModel league;
  final List<MatchModel> teamMatches;
  final List<MatchModel> leagueMatches;
  final List<StandingsRowModel> standings;
  final List<PlayerModel> players;
  final List<TickerModel> tickersToday;

  const TeamsStateLoaded({
    required this.league,
    required this.teamMatches,
    required this.leagueMatches,
    required this.standings,
    required this.players,
    required this.tickersToday,
  });
}

class TeamsStateLoading extends TeamsState {
  const TeamsStateLoading();
}

class TeamsStateError extends TeamsState {
  final String message;
  const TeamsStateError(this.message);
}

import 'package:bloc/bloc.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  final FupaRepository _fupaRepository;

  TeamsCubit(this._fupaRepository) : super(const TeamsStateInitial());

  Future<void> getTeamMatches() async {
    try {
      emit(const TeamsStateLoading());
      final LeagueModel league = await _fupaRepository.getLeague();
      final List<MatchModel> teamMatches =
          await _fupaRepository.getTeamMatches();
      final List<MatchModel> leagueMatches =
          await _fupaRepository.getLeagueMatches();
      final List<StandingsRowModel> standings =
          await _fupaRepository.getStandings();
      final List<PlayerModel> players = await _fupaRepository.getPlayers();
      emit(TeamsStateLoaded(
        league: league,
        teamMatches: teamMatches,
        leagueMatches: leagueMatches,
        standings: standings,
        players: players,
      ));
    } on NetworkException {
      emit(const TeamsStateError("Couldn't fetch data. Device online?"));
    }
  }
}

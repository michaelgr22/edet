import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:meta/meta.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  final FupaRepository _fupaRepository;
  final TickerRepository _tickerRepository;

  TeamsCubit(
    this._fupaRepository,
    this._tickerRepository,
  ) : super(const TeamsStateInitial());

  Future<void> getTeamInformations() async {
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

      List<MatchModel> matchesOnThisDay =
          MatchModel.findMatchesOnThisDay(leagueMatches + teamMatches);
      List<TickerModel> tickersToday = [];

      for (var match in matchesOnThisDay) {
        final List<TickerModel> ticker =
            await _tickerRepository.getTicker(match.id);
        tickersToday += ticker;
      }

      emit(TeamsStateLoaded(
        league: league,
        teamMatches: teamMatches,
        leagueMatches: leagueMatches,
        standings: standings,
        players: players,
        tickersToday: tickersToday,
      ));
    } on NetworkException {
      emit(const TeamsStateError("Couldn't fetch data. Device online?"));
    }
  }
}

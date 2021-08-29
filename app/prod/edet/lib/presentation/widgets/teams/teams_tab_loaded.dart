import 'package:edet/constants.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/teams/league_informations.dart';
import 'package:edet/presentation/widgets/teams/matches_informations.dart';
import 'package:edet/presentation/widgets/teams/statistics_informations.dart';
import 'package:flutter/material.dart';

class TeamsTabLoaded extends StatelessWidget {
  final Future<void> Function(BuildContext context) refreshTeamsInformations;
  final TickerRepository tickerRepository;
  final LeagueModel league;
  final List<MatchModel> teamMatches;
  final List<MatchModel> leagueMatches;
  final List<TickerModel> tickersOfMatches;
  final List<StandingsRowModel> standings;
  final List<PlayerModel> players;

  const TeamsTabLoaded({
    Key? key,
    required this.refreshTeamsInformations,
    required this.tickerRepository,
    required this.league,
    required this.teamMatches,
    required this.leagueMatches,
    required this.tickersOfMatches,
    required this.standings,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView(
        children: [
          LeagueInformations(
            refreshTeamsInformations: refreshTeamsInformations,
            tickerRepository: tickerRepository,
            league: league,
            standings: standings,
            leagueMatches: leagueMatches,
            tickersOfMatches: tickersOfMatches,
            players: players,
          ),
          MatchesInformations(
            refreshTeamsInformations: refreshTeamsInformations,
            tickerRepository: tickerRepository,
            teamMatches: teamMatches,
            tickersOfMatches: tickersOfMatches,
            players: players,
            league: league,
          ),
          StatisticsInformations(
            league: league,
            players: players,
          )
        ],
      ),
    );
  }
}

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/presentation/widgets/teams/league_informations.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_informations.dart';
import 'package:edet_poc/presentation/widgets/teams/statistics_informations.dart';
import 'package:flutter/material.dart';

class TeamsTabLoaded extends StatelessWidget {
  final LeagueModel league;
  final List<MatchModel> teamMatches;
  final List<MatchModel> leagueMatches;
  final List<StandingsRowModel> standings;
  final List<PlayerModel> players;

  const TeamsTabLoaded({
    Key? key,
    required this.league,
    required this.teamMatches,
    required this.leagueMatches,
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
            league: league,
            standings: standings,
            leagueMatches: leagueMatches,
          ),
          MatchesInformations(
            teamMatches: teamMatches,
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

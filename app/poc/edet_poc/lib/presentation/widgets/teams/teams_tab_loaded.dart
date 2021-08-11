import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
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
          )
        ],
      ),
    );
  }
}

class LeagueInformations extends StatelessWidget {
  final LeagueModel league;
  final List<StandingsRowModel> standings;
  final List<MatchModel> leagueMatches;
  const LeagueInformations({
    Key? key,
    required this.league,
    required this.standings,
    required this.leagueMatches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 350.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: Column(
            children: [
              const LeagueInformationsHeadline(),
              LeagueInformationsStandingsRow(standingsRow: standings[0]),
              const RowDivider(),
              LeagueInformationsStandingsRow(standingsRow: standings[1]),
              const RowDivider(),
              LeagueInformationsStandingsRow(standingsRow: standings[2]),
              const RowDivider(),
              LeagueInformationsTSVPosition(
                positionTSV: getRowTSV().position,
              )
            ],
          ),
        ),
      ),
    );
  }

  StandingsRowModel getRowTSV() {
    return standings
        .firstWhere((element) => element.teamShowname == 'TSV Meckenhausen');
  }
}

class RowDivider extends StatelessWidget {
  const RowDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 5.0,
      color: Colors.black,
    );
  }
}

class LeagueInformationsHeadline extends StatelessWidget {
  const LeagueInformationsHeadline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Text(
          'LIGA',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LeagueInformationsStandingsRow extends StatelessWidget {
  final StandingsRowModel standingsRow;

  const LeagueInformationsStandingsRow({Key? key, required this.standingsRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          buildTableTextFields(10.0, standingsRow.position.toString()),
          buildSizedBoxDivider(),
          SizedBox(
            width: 20.0,
            child: Image.network(standingsRow.teamImagelink),
          ),
          buildSizedBoxDivider(),
          Expanded(
            child: Text(standingsRow.teamShowname),
          ),
          buildSizedBoxDivider(),
          buildTableTextFields(10.0, standingsRow.games.toString()),
          buildSizedBoxDivider(),
          buildTableTextFields(35.0,
              "${standingsRow.wins}-${standingsRow.draws}-${standingsRow.loses}"),
          buildSizedBoxDivider(),
          buildTableTextFields(
              20.0, "${standingsRow.goals}:${standingsRow.counteredGoals}"),
          buildSizedBoxDivider(),
          buildTableTextFields(
              10.0, "${standingsRow.goals - standingsRow.counteredGoals}"),
          buildSizedBoxDivider(),
          buildTableTextFields(10.0, standingsRow.points.toString()),
        ],
      ),
    );
  }

  Widget buildSizedBoxDivider() {
    return const SizedBox(
      width: 10.0,
    );
  }

  Widget buildTableTextFields(double size, String text) {
    return SizedBox(
      width: size,
      child: Text(text),
    );
  }
}

class LeagueInformationsTSVPosition extends StatelessWidget {
  final int positionTSV;
  const LeagueInformationsTSVPosition({Key? key, required this.positionTSV})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            Text(
              '$positionTSV',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Position TSV',
              style: TextStyle(
                color: greyTextColor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

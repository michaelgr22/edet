import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/presentation/pages/league_informations_page.dart';
import 'package:edet_poc/presentation/widgets/teams/standings_table.dart';
import 'package:flutter/material.dart';

class LeagueInformations extends StatefulWidget {
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
  State<LeagueInformations> createState() => _LeagueInformationsState();
}

class _LeagueInformationsState extends State<LeagueInformations> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LeagueInformationsPage(
                league: widget.league,
                standings: widget.standings,
                leagueMatches: widget.leagueMatches,
              ),
            ),
          );
        },
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 350.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Column(
              children: [
                const LeagueInformationsHeadline(),
                StandingsTable(
                  standings: widget.standings,
                  numberOfRows: 3,
                  dividerHeight: 5.0,
                  rowHeight: 70.0,
                ),
                LeagueInformationsTSVPosition(
                  positionTSV: getRowTSV().position,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  StandingsRowModel getRowTSV() {
    return widget.standings
        .firstWhere((element) => element.teamShowname == 'TSV Meckenhausen');
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
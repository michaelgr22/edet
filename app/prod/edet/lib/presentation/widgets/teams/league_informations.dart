import 'package:edet/constants.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/pages/league_informations_page.dart';
import 'package:edet/presentation/widgets/teams/informations_container_boilerplate.dart';
import 'package:edet/presentation/widgets/teams/informations_headline.dart';
import 'package:edet/presentation/widgets/teams/standings_table.dart';
import 'package:flutter/material.dart';

class LeagueInformations extends StatefulWidget {
  final Future<void> Function(BuildContext context) refreshTeamsInformations;
  final TickerRepository tickerRepository;
  final LeagueModel league;
  final List<StandingsRowModel> standings;
  final List<MatchModel> leagueMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  const LeagueInformations({
    Key? key,
    required this.refreshTeamsInformations,
    required this.tickerRepository,
    required this.league,
    required this.standings,
    required this.leagueMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  State<LeagueInformations> createState() => _LeagueInformationsState();
}

class _LeagueInformationsState extends State<LeagueInformations> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultContainerPadding,
          right: defaultContainerPadding,
          top: defaultContainerPadding),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LeagueInformationsPage(
                tickerRepository: widget.tickerRepository,
                league: widget.league,
                standings: widget.standings,
                leagueMatches: widget.leagueMatches,
                tickersOfMatches: widget.tickersOfMatches,
                players: widget.players,
              ),
            ),
          ).then((value) => widget.refreshTeamsInformations(context));
        },
        child: InformationsContainerBoilerplate(
          children: [
            const InformationsHeadline(
              headline: 'LIGA',
            ),
            StandingsTable(
              standings: widget.standings,
              numberOfRows: 3,
              dividerHeight: 5.0,
              rowHeight: 70.0,
              isPreview: true,
            ),
            LeagueInformationsTSVPosition(
              positionTSV: getRowTSV().position,
            )
          ],
        ),
      ),
    );
  }

  StandingsRowModel getRowTSV() {
    return widget.standings
        .firstWhere((element) => element.teamShowname.contains('Meckenhausen'));
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

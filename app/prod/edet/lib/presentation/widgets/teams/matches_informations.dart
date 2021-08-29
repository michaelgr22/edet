import 'package:edet/constants.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/pages/matches_informations_page.dart';
import 'package:edet/presentation/widgets/teams/informations_container_boilerplate.dart';
import 'package:edet/presentation/widgets/teams/informations_headline.dart';
import 'package:edet/presentation/widgets/teams/matches_column.dart';
import 'package:flutter/material.dart';

class MatchesInformations extends StatefulWidget {
  final Future<void> Function(BuildContext context) refreshTeamsInformations;
  final TickerRepository tickerRepository;
  final LeagueModel league;
  final List<MatchModel> teamMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  MatchesInformations({
    Key? key,
    required this.refreshTeamsInformations,
    required this.tickerRepository,
    required this.teamMatches,
    required this.tickersOfMatches,
    required this.league,
    required this.players,
  }) : super(key: key);

  @override
  _MatchesInformationsState createState() => _MatchesInformationsState();
}

class _MatchesInformationsState extends State<MatchesInformations> {
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
              builder: (_) => MatchesInformationsPage(
                tickerRepository: widget.tickerRepository,
                matches: widget.teamMatches,
                tickersOfMatches: widget.tickersOfMatches,
                players: widget.players,
                league: widget.league,
              ),
            ),
          ).then((value) => widget.refreshTeamsInformations(context));
        },
        child: InformationsContainerBoilerplate(
          children: [
            const InformationsHeadline(headline: 'SPIELE'),
            MatchesColumn(
              refreshTicker: null,
              scrollMatchPageToIndex: null,
              matches: widget.teamMatches,
              tickersOfMatches: widget.tickersOfMatches,
              players: widget.players,
              numberOfRows: 3,
              dividerHeight: 5.0,
              rowHeight: null,
              isPreview: true,
              isResultColor: true,
              showLeague: true,
            )
          ],
        ),
      ),
    );
  }
}

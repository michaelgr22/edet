import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:edet_poc/presentation/widgets/teams/standings_table.dart';
import 'package:flutter/material.dart';

class LeagueInformationsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final LeagueModel league;
  final List<StandingsRowModel> standings;
  final List<MatchModel> leagueMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  LeagueInformationsPage({
    Key? key,
    required this.league,
    required this.standings,
    required this.leagueMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(submenuAppBarSize),
        child: GlobalAppBar(
          tabs: _tabs,
          showTabBar: false,
        ),
      ),
      body: Container(
        color: greyBackgroundColor,
        child: ListView(
          children: [
            InformationsPageHeadline(
              headline: league.leagueShowname,
              season: league.leagueSeason,
            ),
            StandingsContainer(standings: standings),
            MatchesContainer(
              leagueMatches: leagueMatches,
              tickersOfMatches: tickersOfMatches,
              players: players,
            )
          ],
        ),
      ),
    );
  }
}

class StandingsContainer extends StatelessWidget {
  final List<StandingsRowModel> standings;

  const StandingsContainer({
    Key? key,
    required this.standings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: StandingsTable(
        standings: standings,
        numberOfRows: standings.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
      ),
    );
  }
}

class MatchesContainer extends StatelessWidget {
  final List<MatchModel> leagueMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  const MatchesContainer({
    Key? key,
    required this.leagueMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: MatchesColumn(
        matches: leagueMatches,
        tickersOfMatches: tickersOfMatches,
        players: players,
        numberOfRows: leagueMatches.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
        isResultColor: false,
        showLeague: false,
      ),
    );
  }
}

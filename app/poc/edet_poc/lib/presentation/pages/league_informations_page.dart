import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:edet_poc/presentation/widgets/teams/standings_table.dart';
import 'package:flutter/material.dart';

class LeagueInformationsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final LeagueModel league;
  final List<StandingsRowModel> standings;
  final List<MatchModel> leagueMatches;

  LeagueInformationsPage({
    Key? key,
    required this.league,
    required this.standings,
    required this.leagueMatches,
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
            LeagueHeadline(
              league: league.leagueShowname,
              season: league.leagueSeason,
            ),
            StandingsContainer(standings: standings),
            MatchesContainer(leagueMatches: leagueMatches)
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
    return ContainerBoilerplate(
      child: StandingsTable(
        standings: standings,
        numberOfRows: standings.length,
        dividerHeight: 3.0,
        rowHeight: 30.0,
      ),
    );
  }
}

class ContainerBoilerplate extends StatelessWidget {
  final Widget child;

  const ContainerBoilerplate({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: child,
        ),
      ),
    );
  }
}

class LeagueHeadline extends StatelessWidget {
  final String league;
  final String season;

  const LeagueHeadline({
    Key? key,
    required this.league,
    required this.season,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Column(
              children: [
                Text(
                  league,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  season,
                  style: const TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MatchesContainer extends StatelessWidget {
  final List<MatchModel> leagueMatches;
  const MatchesContainer({Key? key, required this.leagueMatches})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerBoilerplate(
      child: MatchesColumn(
        matches: leagueMatches,
        numberOfRows: leagueMatches.length,
        dividerHeight: 3.0,
        rowHeight: 30.0,
      ),
    );
  }
}

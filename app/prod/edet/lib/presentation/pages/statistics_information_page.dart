import 'package:edet/constants.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/presentation/widgets/global/global_app_bar.dart';
import 'package:edet/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet/presentation/widgets/teams/players_statistics_column.dart';
import 'package:flutter/material.dart';

class StatisticsInformationPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final LeagueModel league;
  final List<PlayerModel> players;

  StatisticsInformationPage({
    Key? key,
    required this.players,
    required this.league,
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
        child: ListView(children: [
          InformationsPageHeadline(
            headline: 'Statistiken',
            season: league.leagueSeason,
          ),
          StatisticsContainer(
            players: players,
            headline: 'TORJÄGER',
            isGoalsStat: true,
          ),
          StatisticsContainer(
            players: players,
            headline: 'EINSÄTZE',
            isGoalsStat: false,
          )
        ]),
      ),
    );
  }
}

class StatisticsContainer extends StatelessWidget {
  final List<PlayerModel> players;
  final String headline;
  final bool isGoalsStat;

  const StatisticsContainer({
    Key? key,
    required this.players,
    required this.headline,
    required this.isGoalsStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      headline: headline,
      child: PlayersStatisticsColumn(
        players: players,
        numberOfRows: players.length,
        dividerHeight: 3.0,
        rowHeight: 50.0,
        isGoalsStat: isGoalsStat,
      ),
    );
  }
}

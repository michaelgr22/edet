import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:flutter/material.dart';

class MatchesInformationsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final LeagueModel league;
  final List<MatchModel> teamMatches;

  MatchesInformationsPage({
    Key? key,
    required this.teamMatches,
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
            headline: 'Spiele TSV',
            season: league.leagueSeason,
          ),
          TeamMatchesContainer(
            teamMatches: teamMatches,
          ),
        ]),
      ),
    );
  }
}

class TeamMatchesContainer extends StatelessWidget {
  final List<MatchModel> teamMatches;

  const TeamMatchesContainer({
    Key? key,
    required this.teamMatches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: MatchesColumn(
        matches: teamMatches,
        numberOfRows: teamMatches.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
        isResultColor: true,
        showLeague: true,
      ),
    );
  }
}

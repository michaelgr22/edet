import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:flutter/material.dart';

class LeagueInformationsPage extends StatefulWidget {
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
  _LeagueInformationsPageState createState() => _LeagueInformationsPageState();
}

class _LeagueInformationsPageState extends State<LeagueInformationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(submenuAppBarSize),
        child: GlobalAppBar(
          tabs: widget._tabs,
          showTabBar: false,
        ),
      ),
      body: Container(
        color: greyBackgroundColor,
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}

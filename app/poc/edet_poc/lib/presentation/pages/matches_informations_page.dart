import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:flutter/material.dart';

class MatchesInformationsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final List<MatchModel> teamMatches;

  MatchesInformationsPage({
    Key? key,
    required this.teamMatches,
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
          children: [],
        ),
      ),
    );
  }
}

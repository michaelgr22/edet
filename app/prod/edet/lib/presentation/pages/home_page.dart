import 'package:edet/presentation/widgets/teams/teams_tab.dart';
import 'package:flutter/material.dart';

import 'package:edet/constants.dart';
import 'package:edet/presentation/widgets/news/news_list.dart';
import 'package:edet/presentation/widgets/global/global_app_bar.dart';

class HomePage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: appbarTaps.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(defaultAppBarSize),
          child: GlobalAppBar(
            tabs: _tabs,
            showTabBar: true,
          ),
        ),
        body: TabBarContent(
          tabs: _tabs,
        ),
      ),
    );
  }
}

class TabBarContent extends StatelessWidget {
  final List<Tab> tabs;

  TabBarContent({required this.tabs});

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      NewsList(),
      TeamsTab(
          teamname: 'tsv-meckenhausen', teamclass: 'm1', teamseason: '2021-22'),
      TeamsTab(
          teamname: 'tsv-meckenhausen', teamclass: 'm2', teamseason: '2021-22'),
    ]);
  }
}

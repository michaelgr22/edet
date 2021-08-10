import 'package:flutter/material.dart';

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/presentation/widgets/news/news_list.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';

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
      Text("zwei"),
      Text("drei"),
    ]);
  }
}

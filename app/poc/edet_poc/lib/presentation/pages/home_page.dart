import 'package:flutter/material.dart';

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/presentation/widgets/news/news_list.dart';

class HomePage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: appbarTaps.length,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: GlobalAppBar(
              tabs: _tabs,
            )),
        body: TabBarContent(
          tabs: _tabs,
        ),
      ),
    );
  }
}

class GlobalAppBar extends StatelessWidget {
  final List<Tab> tabs;

  GlobalAppBar({required this.tabs});

  static const String _title = 'TSV Meckenhausen';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: TabBar(
        tabs: tabs,
        indicatorColor: yellowTextColor,
        labelColor: yellowTextColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: blackBackgroundColor,
      title: const Text(
        _title,
        style: TextStyle(
          color: yellowTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
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

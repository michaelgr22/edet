import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget {
  final List<Tab> tabs;
  final bool showTabBar;

  GlobalAppBar({required this.tabs, required this.showTabBar});

  static const String _title = 'TSV Meckenhausen';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: showTabBar
          ? TabBar(
              tabs: tabs,
              indicatorColor: yellowTextColor,
              labelColor: yellowTextColor,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
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

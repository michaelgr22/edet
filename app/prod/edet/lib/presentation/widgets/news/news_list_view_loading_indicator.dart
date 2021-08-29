import 'package:flutter/material.dart';

import 'package:edet/constants.dart';

class NewsListViewLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (c, index) {
          return NewsListViewLoadingCard();
        },
      ),
    );
  }
}

class NewsListViewLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Container(
        width: double.infinity,
        height: 80.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
      ),
    );
  }
}

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/presentation/widgets/teams/match_row.dart';
import 'package:flutter/material.dart';

class MatchDetailsPageLoaded extends StatelessWidget {
  final MatchModel match;
  final List<TickerModel> ticker;

  const MatchDetailsPageLoaded({
    Key? key,
    required this.match,
    required this.ticker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView(
        children: [buildMatchResultContainer()],
      ),
    );
  }

  Widget buildMatchResultContainer() {
    return Padding(
      padding: const EdgeInsets.all(defaultContainerPadding),
      child: Container(
        color: Colors.white,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              match.leagueShowname,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          MatchRow(
            match: match,
            rowHeight: 130.0,
            isResultColor: true,
            middleContainerWidth: 60.0,
            middleContainerHeight: 60.0,
            isDetailsPage: true,
          ),
        ]),
      ),
    );
  }
}

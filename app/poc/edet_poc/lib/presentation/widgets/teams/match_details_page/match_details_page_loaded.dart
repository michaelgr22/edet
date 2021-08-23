import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/presentation/widgets/teams/liveticker_row.dart';
import 'package:edet_poc/presentation/widgets/teams/match_row.dart';
import 'package:edet_poc/presentation/widgets/teams/row_divider.dart';
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
      child: ListView(children: [
        buildMatchResultContainer(),
        LiveTicker(
          ticker: ticker,
          match: match,
        ),
      ]),
    );
  }

  Widget buildMatchResultContainer() {
    return Padding(
      padding: const EdgeInsets.all(defaultContainerPadding),
      child: Container(
        color: Colors.white,
        child: Column(children: [
          MatchDetailsHeadline(headline: match.leagueShowname),
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

class MatchDetailsHeadline extends StatelessWidget {
  final String headline;

  const MatchDetailsHeadline({
    Key? key,
    required this.headline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        headline,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class LiveTicker extends StatelessWidget {
  final List<TickerModel> ticker;
  final MatchModel match;

  const LiveTicker({
    Key? key,
    required this.ticker,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultContainerPadding),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: MatchDetailsHeadline(headline: 'Liveticker'),
            ),
            ...buildTicker()
          ],
        ),
      ),
    );
  }

  List<Widget> buildTicker() {
    return ticker
        .map((tickerEntry) => Column(
              children: [
                LiveTickerRow(
                  tickerEntry: tickerEntry,
                  match: match,
                ),
                const RowDivider(height: 5.0)
              ],
            ))
        .toList();
  }
}

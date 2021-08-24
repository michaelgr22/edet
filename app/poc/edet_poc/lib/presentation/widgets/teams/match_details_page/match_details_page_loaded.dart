import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/ticker_action_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/presentation/widgets/teams/liveticker/liveticker_add_entry.dart';
import 'package:edet_poc/presentation/widgets/teams/liveticker/liveticker_elevated_button.dart';
import 'package:edet_poc/presentation/widgets/teams/liveticker/liveticker_row.dart';
import 'package:edet_poc/presentation/widgets/teams/match_row.dart';
import 'package:edet_poc/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';

class MatchDetailsPageLoaded extends StatelessWidget {
  final Future<void> Function(BuildContext context) refreshTicker;
  final MatchModel match;
  final List<TickerModel> ticker;
  final List<TickerActionModel> actions;
  final List<PlayerModel> players;

  const MatchDetailsPageLoaded({
    Key? key,
    required this.refreshTicker,
    required this.match,
    required this.ticker,
    required this.actions,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: RefreshIndicator(
        onRefresh: () => refreshTicker(context),
        child: ListView(children: [
          buildMatchResultContainer(),
          LiveTicker(
            refreshTicker: refreshTicker,
            ticker: ticker,
            match: match,
            actions: actions,
            players: players,
          ),
        ]),
      ),
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

class LiveTicker extends StatefulWidget {
  final Future<void> Function(BuildContext context) refreshTicker;
  final List<TickerModel> ticker;
  final MatchModel match;
  final List<TickerActionModel> actions;
  final List<PlayerModel> players;

  LiveTicker({
    Key? key,
    required this.refreshTicker,
    required this.ticker,
    required this.match,
    required this.actions,
    required this.players,
  }) : super(key: key);

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker> {
  bool showAddFields = false;

  void _showAddFields(bool show) {
    setState(() {
      showAddFields = show;
    });
  }

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
            LiveTickerAddEntry(
              notifyParent: _showAddFields,
              refreshTicker: widget.refreshTicker,
              actions: widget.actions,
              players: widget.players,
              match: widget.match,
              isVisible: showAddFields,
            ),
            buildAddButton(),
            ...buildTicker()
          ],
        ),
      ),
    );
  }

  List<Widget> buildTicker() {
    return widget.ticker
        .map((tickerEntry) => Column(
              children: [
                LiveTickerRow(
                  tickerEntry: tickerEntry,
                  match: widget.match,
                ),
                const RowDivider(height: 5.0)
              ],
            ))
        .toList();
  }

  Widget buildAddButton() {
    return Visibility(
      visible: DateTime.now().isAfter(widget.match.dateTime) && !showAddFields,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: LiveTickerElevatedButton(
          text: 'Eintrag hinzufügen',
          onPressed: () => _showAddFields(true),
        ),
      ),
    );
  }
}

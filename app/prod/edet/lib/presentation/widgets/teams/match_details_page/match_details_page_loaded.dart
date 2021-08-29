import 'package:edet/constants.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_action_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/presentation/widgets/teams/liveticker/liveticker_add_entry.dart';
import 'package:edet/presentation/widgets/teams/liveticker/liveticker_elevated_button.dart';
import 'package:edet/presentation/widgets/teams/liveticker/liveticker_row.dart';
import 'package:edet/presentation/widgets/teams/match_row.dart';
import 'package:edet/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
        color: Colors.black,
        onRefresh: () => refreshTicker(context),
        child: ListView(
          children: [
            buildMatchResultContainer(),
            DateTime.now().isAfter(match.dateTime)
                ? LiveTicker(
                    refreshTicker: refreshTicker,
                    ticker: ticker,
                    match: match,
                    actions: actions,
                    players: players,
                  )
                : buildInfoContainer(context),
          ],
        ),
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
            ticker: ticker,
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

  Widget buildInfoContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultContainerPadding),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: Text(
              "Anstoß am " +
                  kickingOffDate(context) +
                  " um " +
                  kickingOffTime(context) +
                  " Uhr",
              style:
                  const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  String kickingOffDate(BuildContext context) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String dateTime =
        DateFormat("dd.MM.yy", languageCode).format(match.dateTime);
    return dateTime;
  }

  String kickingOffTime(BuildContext context) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String dateTime = DateFormat("kk:mm", languageCode).format(match.dateTime);
    return dateTime;
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
            ...buildTicker(),
            const SizedBox(
              height: 30.0,
            ),
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
                  refreshTicker: widget.refreshTicker,
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

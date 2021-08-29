import 'package:edet/core/extensions.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/presentation/pages/match_details_page.dart';
import 'package:edet/presentation/widgets/teams/match_row.dart';
import 'package:edet/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MatchesColumn extends StatelessWidget {
  final Future<void> Function(BuildContext context, MatchModel? match)?
      refreshTicker;
  final Function(int index)? scrollMatchPageToIndex;
  final List<MatchModel> matches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;
  final int numberOfRows;
  final double dividerHeight;
  final double? rowHeight;
  final bool isPreview;
  final bool isResultColor;
  final bool showLeague;

  const MatchesColumn({
    Key? key,
    required this.refreshTicker,
    required this.scrollMatchPageToIndex,
    required this.matches,
    required this.tickersOfMatches,
    required this.players,
    required this.numberOfRows,
    required this.dividerHeight,
    required this.rowHeight,
    required this.isPreview,
    required this.isResultColor,
    required this.showLeague,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildMatchesWithDateDividers(),
    );
  }

  List<MatchModel> matchesToShow() {
    if (isPreview) {
      int lastMatchIndex = findIndexOfLastMatch();
      if ((lastMatchIndex + numberOfRows) >= matches.length) {
        return matches.sublist(
            matches.length - 1 - numberOfRows, matches.length - 1);
      } else {
        return matches.sublist(lastMatchIndex, lastMatchIndex + numberOfRows);
      }
    } else {
      return matches.take(numberOfRows).toList();
    }
  }

  int findIndexOfLastMatch() {
    DateTime today = DateTime.now();
    int lastMatchIndex = 1;
    bool found = false;
    matches.asMap().forEach((index, match) {
      if (!found && today.isBefore(match.dateTime)) {
        lastMatchIndex = index - 1;
        found = true;
      }
    });
    return lastMatchIndex;
  }

  List<Widget> buildMatchesWithDateDividers() {
    List<MatchModel> matches = matchesToShow();
    List<Widget> widgets = [];
    DateTime date = matches[0].dateTime;
    bool isfirst = true;

    widgets.add(DateDivider(dateTime: matches[0].dateTime));
    for (int i = 0; i < matches.length; i++) {
      if (matches[i].dateTime.isSameDate(date)) {
        isfirst = false;
      } else {
        isfirst = true;
        date = matches[i].dateTime;
      }
      if (isfirst) {
        widgets.add(DateDivider(dateTime: matches[i].dateTime));
        isfirst = false;
      }

      List<TickerModel> tickerOfMatch = tickersOfMatches
          .where((tickerEntry) => tickerEntry.matchId == matches[i].id)
          .toList();

      widgets.add(
        MatchContainer(
          refreshTicker: refreshTicker,
          scrollMatchPageToIndex: scrollMatchPageToIndex,
          match: matches[i],
          indexOfMatch: i,
          ticker: tickerOfMatch,
          players: players,
          rowHeight: rowHeight,
          dividerHeight: dividerHeight,
          isResultColor: isResultColor,
          showLeague: showLeague,
          isPreview: isPreview,
        ),
      );
    }
    return widgets;
  }
}

class MatchContainer extends StatefulWidget {
  final Future<void> Function(BuildContext context, MatchModel? match)?
      refreshTicker;
  final Function(int index)? scrollMatchPageToIndex;
  final MatchModel match;
  final int indexOfMatch;
  final List<TickerModel> ticker;
  final List<PlayerModel> players;
  final double? rowHeight;
  final double dividerHeight;
  final bool isResultColor;
  final bool showLeague;
  final bool isPreview;

  const MatchContainer({
    Key? key,
    required this.refreshTicker,
    required this.scrollMatchPageToIndex,
    required this.match,
    required this.indexOfMatch,
    required this.ticker,
    required this.players,
    required this.rowHeight,
    required this.dividerHeight,
    required this.isResultColor,
    required this.showLeague,
    required this.isPreview,
  }) : super(key: key);

  @override
  State<MatchContainer> createState() => _MatchContainerState();
}

class _MatchContainerState extends State<MatchContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.isPreview) {
      return buildMatchContainer();
    }
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatchDetailsPage(
                match: widget.match,
                players: widget.players,
              ),
            ),
          ).then(
            (value) async {
              if (widget.refreshTicker != null) {
                await widget.refreshTicker!(context,
                    widget.match.isLivetickerTime() ? widget.match : null);
              }
              if (widget.scrollMatchPageToIndex != null) {
                widget.scrollMatchPageToIndex!(widget.indexOfMatch);
              }
            },
          );
        },
        child: buildMatchContainer());
  }

  Widget buildMatchContainer() {
    return Column(
      children: [
        widget.showLeague
            ? Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(widget.match.leagueShowname),
              )
            : const SizedBox(height: 0.0, width: 0.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: MatchRow(
            match: widget.match,
            ticker: widget.ticker,
            rowHeight: widget.rowHeight,
            isResultColor: widget.isResultColor,
          ),
        ),
        RowDivider(height: widget.dividerHeight)
      ],
    );
  }
}

class DateDivider extends StatelessWidget {
  final DateTime dateTime;

  const DateDivider({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    String languageCode = Localizations.localeOf(context).languageCode;
    String dateTime =
        DateFormat("E., dd.MM.yy", languageCode).format(this.dateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        dateTime,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:edet_poc/core/extensions.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MatchesColumn extends StatelessWidget {
  final List<MatchModel> matches;
  final int numberOfRows;
  final double dividerHeight;
  final double? rowHeight;
  final bool isPreview;
  final bool isResultColor;

  const MatchesColumn({
    Key? key,
    required this.matches,
    required this.numberOfRows,
    required this.dividerHeight,
    required this.rowHeight,
    required this.isPreview,
    required this.isResultColor,
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
      widgets.add(MatchContainer(
        match: matches[i],
        rowHeight: rowHeight,
        dividerHeight: dividerHeight,
        isResultColor: isResultColor,
      ));
    }
    return widgets;
  }
}

class MatchContainer extends StatelessWidget {
  final MatchModel match;
  final double? rowHeight;
  final double dividerHeight;
  final bool isResultColor;

  const MatchContainer({
    Key? key,
    required this.match,
    required this.rowHeight,
    required this.dividerHeight,
    required this.isResultColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: MatchRow(
            match: match,
            rowHeight: rowHeight,
            isResultColor: isResultColor,
          ),
        ),
        RowDivider(height: dividerHeight)
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

class MatchRow extends StatelessWidget {
  final MatchModel match;
  final double? rowHeight;
  final bool isResultColor;

  const MatchRow({
    Key? key,
    required this.match,
    required this.rowHeight,
    required this.isResultColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double middleContainerWidth = 60.0;
    var screenSize = MediaQuery.of(context).size;

    return Container(
      height: rowHeight,
      color: Colors.white,
      child: Row(
        children: [
          buildTeamContainer(match.homeTeamShowname, match.homeTeamImagelink,
              true, screenSize, middleContainerWidth),
          buildResultContainer(middleContainerWidth),
          buildTeamContainer(match.awayTeamShowname, match.awayTeamImagelink,
              false, screenSize, middleContainerWidth),
        ],
      ),
    );
  }

  Widget buildTeamContainer(String teamShowname, String teamImagelink,
      bool isHomeTeam, Size size, double middleContainerWidth) {
    double width = (size.width - middleContainerWidth - 70.0) / 2;
    double imageWidth = 20.0;
    if (isHomeTeam) {
      return SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Text(teamShowname),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: imageWidth,
                child: Image.network(teamImagelink),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: imageWidth,
                child: Image.network(teamImagelink),
              ),
            ),
            Expanded(
              child: Text(teamShowname),
            ),
          ],
        ),
      );
    }
  }

  Widget buildResultContainer(double middleContainerWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: middleContainerWidth,
        height: 20.0,
        color: isResultColor ? chooseColor() : const Color(0xFFDCDCDC),
        child: Align(
          alignment: Alignment.center,
          child: buildResult(match),
        ),
      ),
    );
  }

  Color chooseColor() {
    int goalsTSV;
    int goalsOther;

    if (match.homeTeamShowname.contains('Meckenhausen')) {
      goalsTSV = match.homeGoals;
      goalsOther = match.awayGoals;
    } else {
      goalsTSV = match.awayGoals;
      goalsOther = match.homeGoals;
    }

    if (goalsTSV > goalsOther) return Colors.green;
    if (goalsTSV < goalsOther) return Colors.red;
    return const Color(0xFFDCDCDC);
  }

  Widget buildResult(MatchModel match) {
    String formattedTime = DateFormat('kk:mm').format(match.dateTime);
    return match.homeGoals != -1 && match.awayGoals != -1
        ? buildResultText("${match.homeGoals}:${match.awayGoals}")
        : !match.cancelled
            ? buildResultText(formattedTime)
            : buildResultText("abg");
  }

  Widget buildResultText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

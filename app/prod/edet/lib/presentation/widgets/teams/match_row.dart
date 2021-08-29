import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchRow extends StatelessWidget {
  final MatchModel match;
  final List<TickerModel> ticker;
  final double? rowHeight;
  final bool isResultColor;
  final double middleContainerWidth;
  final double middleContainerHeight;
  final bool isDetailsPage;

  const MatchRow({
    Key? key,
    required this.match,
    required this.ticker,
    required this.rowHeight,
    required this.isResultColor,
    this.middleContainerWidth = 60.0,
    this.middleContainerHeight = 20.0,
    this.isDetailsPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      height: rowHeight,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTeamContainer(match.homeTeamShowname, match.homeTeamImagelink,
              true, screenSize, middleContainerWidth),
          buildResultContainer(middleContainerWidth, middleContainerHeight),
          buildTeamContainer(match.awayTeamShowname, match.awayTeamImagelink,
              false, screenSize, middleContainerWidth),
        ],
      ),
    );
  }

  Widget buildTeamContainer(String teamShowname, String teamImagelink,
      bool isHomeTeam, Size size, double middleContainerWidth) {
    double width = (size.width - middleContainerWidth - 70.0) / 2;
    if (isDetailsPage) {
      return SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              teamImagelink,
              scale: 0.6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                teamShowname,
                style: const TextStyle(fontSize: 13.0),
              ),
            )
          ],
        ),
      );
    } else {
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
  }

  Widget buildResultContainer(
      double middleContainerWidth, double middleContainerHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: middleContainerWidth,
        height: middleContainerHeight,
        color: isResultColor ? chooseColor() : const Color(0xFFDCDCDC),
        child: Align(
          alignment: Alignment.center,
          child: buildResult(match),
        ),
      ),
    );
  }

  Color chooseColor() {
    if (match.isLive() && !isDetailsPage) {
      return Colors.yellow;
    }

    int homeGoals = match.homeGoals;
    int awayGoals = match.awayGoals;

    if (showTickerResult(match)) {
      homeGoals = countTickerGoalsOfTeam(match.homeTeamId);
      awayGoals = countTickerGoalsOfTeam(match.awayTeamId);
    }

    int goalsTSV;
    int goalsOther;

    if (match.homeTeamShowname.contains('Meckenhausen')) {
      goalsTSV = homeGoals;
      goalsOther = awayGoals;
    } else {
      goalsTSV = awayGoals;
      goalsOther = homeGoals;
    }
    if (goalsTSV > goalsOther) return Colors.green;
    if (goalsTSV < goalsOther) return Colors.red;
    return const Color(0xFFDCDCDC);
  }

  bool showTickerResult(MatchModel match) {
    if (match.isLivetickerTime() && ticker.isNotEmpty) {
      return true;
    }
    return false;
  }

  int countTickerGoalsOfTeam(int teamId) {
    return ticker
        .where((tickerEntry) =>
            tickerEntry.teamId == teamId &&
            (tickerEntry.actionId == 1 || tickerEntry.actionId == 2))
        .length;
  }

  Widget buildResult(MatchModel match) {
    if (match.isLive() && !isDetailsPage) {
      return buildResultText('LIVE');
    }

    int homeGoals = match.homeGoals;
    int awayGoals = match.awayGoals;

    if (showTickerResult(match)) {
      homeGoals = countTickerGoalsOfTeam(match.homeTeamId);
      awayGoals = countTickerGoalsOfTeam(match.awayTeamId);
    }

    String formattedTime = DateFormat('kk:mm').format(match.dateTime);
    return homeGoals != -1 && awayGoals != -1
        ? buildResultText("$homeGoals:$awayGoals")
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

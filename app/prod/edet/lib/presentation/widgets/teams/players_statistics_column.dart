import 'package:edet/data/models/player_model.dart';
import 'package:edet/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';

class PlayersStatisticsColumn extends StatelessWidget {
  final List<PlayerModel> players;
  final int numberOfRows;
  final double dividerHeight;
  final double? rowHeight;
  final bool isGoalsStat;

  const PlayersStatisticsColumn({
    Key? key,
    required this.players,
    required this.numberOfRows,
    required this.dividerHeight,
    required this.rowHeight,
    required this.isGoalsStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: playersToShow()
          .map((player) => StatisticRowContainer(
              player: player,
              dividerHeight: dividerHeight,
              rowHeight: rowHeight,
              isGoalsStat: isGoalsStat))
          .toList(),
    );
  }

  List<PlayerModel> playersToShow() {
    List<PlayerModel> p = players;
    try {
      isGoalsStat
          ? p.sort((a, b) => a.goals!.compareTo(b.goals!))
          : p.sort((a, b) => a.deployments!.compareTo(b.deployments!));
    } on Exception {}
    return p.reversed.take(numberOfRows).toList();
  }
}

class StatisticRowContainer extends StatelessWidget {
  final PlayerModel player;
  final double dividerHeight;
  final double? rowHeight;
  final bool isGoalsStat;

  const StatisticRowContainer({
    Key? key,
    required this.player,
    required this.dividerHeight,
    required this.rowHeight,
    required this.isGoalsStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: StatisticRow(
            player: player,
            rowHeight: rowHeight,
            isGoalsStat: isGoalsStat,
          ),
        ),
        RowDivider(height: dividerHeight)
      ],
    );
  }
}

class StatisticRow extends StatelessWidget {
  final PlayerModel player;
  final double? rowHeight;
  final bool isGoalsStat;

  const StatisticRow({
    Key? key,
    required this.player,
    required this.rowHeight,
    required this.isGoalsStat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rowHeight,
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: buildImage(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: buildName(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: buildStat(),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    Widget image;
    if (player.imagelink != null && !player.imagelink!.endsWith('.svg')) {
      image = Image.network(player.imagelink.toString());
    } else {
      image = Image.asset('assets/images/player_placeholder_image.jpeg');
    }
    return SizedBox(width: 75.0, child: image);
  }

  Widget buildName() {
    return SizedBox(
      width: 200.0,
      child: Row(
        children: [
          Text(player.firstname != null ? player.firstname.toString() : ""),
          const Text("  "),
          Text(player.lastname != null ? player.lastname.toString() : ""),
        ],
      ),
    );
  }

  Widget buildStat() {
    return Text(
        isGoalsStat ? player.goals.toString() : player.deployments.toString());
  }
}

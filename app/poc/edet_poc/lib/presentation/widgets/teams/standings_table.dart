import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:flutter/material.dart';

class StandingsTable extends StatelessWidget {
  final List<StandingsRowModel> standings;
  final int numberOfRows;
  final double dividerHeight;

  const StandingsTable({
    Key? key,
    required this.standings,
    required this.numberOfRows,
    required this.dividerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: standingsToShow()
          .map(
            (row) => Column(
              children: [
                LeagueInformationsStandingsRow(
                  standingsRow: row,
                ),
                RowDivider(height: dividerHeight),
              ],
            ),
          )
          .toList(),
    );
  }

  List<StandingsRowModel> standingsToShow() {
    return standings.take(numberOfRows).toList();
  }
}

class LeagueInformationsStandingsRow extends StatelessWidget {
  final StandingsRowModel standingsRow;

  const LeagueInformationsStandingsRow({Key? key, required this.standingsRow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          buildTableTextFields(10.0, standingsRow.position.toString()),
          buildSizedBoxDivider(),
          SizedBox(
            width: 20.0,
            child: Image.network(standingsRow.teamImagelink),
          ),
          buildSizedBoxDivider(),
          Expanded(
            child: Text(standingsRow.teamShowname),
          ),
          buildSizedBoxDivider(),
          buildTableTextFields(10.0, standingsRow.games.toString()),
          buildSizedBoxDivider(),
          buildTableTextFields(38.0,
              "${standingsRow.wins}-${standingsRow.draws}-${standingsRow.loses}"),
          buildSizedBoxDivider(),
          buildTableTextFields(
              20.0, "${standingsRow.goals}:${standingsRow.counteredGoals}"),
          buildSizedBoxDivider(),
          buildTableTextFields(
              10.0, "${standingsRow.goals - standingsRow.counteredGoals}"),
          buildSizedBoxDivider(),
          buildTableTextFields(10.0, standingsRow.points.toString()),
        ],
      ),
    );
  }

  Widget buildSizedBoxDivider() {
    return const SizedBox(
      width: 10.0,
    );
  }

  Widget buildTableTextFields(double size, String text) {
    return SizedBox(
      width: size,
      child: Text(text),
    );
  }
}

class RowDivider extends StatelessWidget {
  final double height;
  const RowDivider({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: Colors.black,
    );
  }
}

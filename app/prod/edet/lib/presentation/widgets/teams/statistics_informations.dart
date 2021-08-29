import 'package:edet/constants.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/presentation/pages/statistics_information_page.dart';
import 'package:edet/presentation/widgets/teams/informations_container_boilerplate.dart';
import 'package:edet/presentation/widgets/teams/informations_headline.dart';
import 'package:edet/presentation/widgets/teams/players_statistics_column.dart';
import 'package:flutter/material.dart';

class StatisticsInformations extends StatefulWidget {
  final LeagueModel league;
  final List<PlayerModel> players;

  StatisticsInformations({
    Key? key,
    required this.league,
    required this.players,
  }) : super(key: key);

  @override
  _StatisticsInformationsState createState() => _StatisticsInformationsState();
}

class _StatisticsInformationsState extends State<StatisticsInformations> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        defaultContainerPadding,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StatisticsInformationPage(
                players: widget.players,
                league: widget.league,
              ),
            ),
          );
        },
        child: InformationsContainerBoilerplate(
          children: [
            const InformationsHeadline(headline: 'STATISTIKEN'),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Torjäger",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            PlayersStatisticsColumn(
              players: widget.players,
              numberOfRows: 3,
              dividerHeight: 5.0,
              rowHeight: 50.0,
              isGoalsStat: true,
            )
          ],
        ),
      ),
    );
  }
}

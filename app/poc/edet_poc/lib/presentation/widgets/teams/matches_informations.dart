import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/presentation/pages/matches_informations_page.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_headline.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:flutter/material.dart';

class MatchesInformations extends StatefulWidget {
  final List<MatchModel> teamMatches;

  MatchesInformations({
    Key? key,
    required this.teamMatches,
  }) : super(key: key);

  @override
  _MatchesInformationsState createState() => _MatchesInformationsState();
}

class _MatchesInformationsState extends State<MatchesInformations> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: informationsPreviewContainerPadding,
          right: informationsPreviewContainerPadding,
          top: informationsPreviewContainerPadding),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatchesInformationsPage(
                teamMatches: widget.teamMatches,
              ),
            ),
          );
        },
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Column(
              children: [
                const InformationsHeadline(headline: 'SPIELE'),
                MatchesColumn(
                  matches: widget.teamMatches,
                  numberOfRows: 3,
                  dividerHeight: 5.0,
                  rowHeight: 50.0,
                  isPreview: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

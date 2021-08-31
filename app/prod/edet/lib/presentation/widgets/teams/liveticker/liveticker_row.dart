import 'package:edet/constants.dart';
import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/global/global_snack_bar.dart';
import 'package:edet/presentation/widgets/teams/row_divider.dart';
import 'package:flutter/material.dart';

class LiveTickerRow extends StatelessWidget {
  final Future<void> Function(BuildContext context) refreshTicker;
  final TickerModel tickerEntry;
  final MatchModel match;

  const LiveTickerRow({
    Key? key,
    required this.refreshTicker,
    required this.tickerEntry,
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const minuteWidth = 40.0;
    const imageWidth = 30.0;
    const minuteAndImagePadding = 12.0;
    const textPadding = 20.0;
    const iconPadding = 15.0;
    const iconWidth = 20.0;
    Map<String, String> properties = propertyManager();
    return properties['icon_path']!.isNotEmpty
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: minuteAndImagePadding),
                child: SizedBox(
                  width: minuteWidth,
                  child: Text(
                    "${tickerEntry.minute}'",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: minuteAndImagePadding),
                child: SizedBox(
                  width: imageWidth,
                  child: Image.asset(
                    properties['icon_path'].toString(),
                    scale: 15.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: textPadding),
                child: SizedBox(
                  width: screenSize.width -
                      minuteWidth -
                      imageWidth -
                      minuteAndImagePadding * 2 -
                      textPadding -
                      iconPadding * 2 -
                      defaultContainerPadding * 2 -
                      iconWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildTickerTextColumn(properties),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: iconPadding),
                child: buildDeleteButton(context, iconWidth),
              )
            ],
          )
        : const Text("Error");
  }

  List<Widget> buildTickerTextColumn(Map<String, String> properties) {
    List<Widget> widgets = [];

    if (properties['content'] != null) {
      widgets.add(buildText(properties['content'], 15.0, FontWeight.bold));
    }

    if (properties['content_detail'] != null) {
      widgets.add(buildText(properties['content_detail'], 13.5, null));
    }

    if (properties['content_detail_extra'] != null) {
      widgets.add(buildText(properties['content_detail_extra'], 13.5, null));
    }

    if (tickerEntry.comment != null && tickerEntry.comment!.isNotEmpty) {
      widgets.add(const RowDivider(height: 3.0));
      widgets.add(buildText(tickerEntry.comment, 12.5, null));
    }

    return widgets;
  }

  Widget buildText(String? content, double fontSize, FontWeight? fontWeight) {
    return content!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              content,
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
            ),
          )
        : const SizedBox(
            height: 7.5,
          );
  }

  Map<String, String> propertyManager() {
    String livetickerIconsPath = 'assets/icons/liveticker/';
    switch (tickerEntry.actionId) {
      case 1:
        {
          return <String, String>{
            'icon_path': livetickerIconsPath + 'goal.png',
            'content': 'Tor für ${tickerEntry.teamShowname}',
            'content_detail': tickerEntry.player1Id != null
                ? 'Torschütze: ${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                : '',
            'content_detail_extra': tickerEntry.player2Id != null
                ? 'Vorlage: ${tickerEntry.player2Firstname} ${tickerEntry.player2Lastname}'
                : ''
          };
        }
      case 2:
        {
          final String ownGoalTeam =
              tickerEntry.teamShowname == match.homeTeamShowname
                  ? match.awayTeamShowname
                  : match.homeTeamShowname;
          return <String, String>{
            'icon_path': livetickerIconsPath + 'goal.png',
            'content': 'Tor für ${tickerEntry.teamShowname}',
            'content_detail': 'Eigentor von $ownGoalTeam',
            'content_detail_extra': tickerEntry.player1Id != null
                ? 'Eigentor von ${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                : ''
          };
        }
      case 3:
        {
          return <String, String>{
            'icon_path': livetickerIconsPath + 'arrows.png',
            'content': 'Wechsel bei ${tickerEntry.teamShowname}',
            'content_detail': (tickerEntry.player2Id != null
                    ? '${tickerEntry.player2Firstname} ${tickerEntry.player2Lastname} kommt ins Spiel'
                    : '') +
                (tickerEntry.player1Id != null
                    ? ' für ${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                    : ''),
            'content_detail_extra': ''
          };
        }
      case 4:
        {
          return <String, String>{
            'icon_path': livetickerIconsPath + 'yellow-card.png',
            'content': 'Gelbe Karte für ${tickerEntry.teamShowname}',
            'content_detail': tickerEntry.player1Id != null
                ? '${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                : '',
            'content_detail_extra': ''
          };
        }
      case 5:
        {
          return <String, String>{
            'icon_path': livetickerIconsPath + 'red-card.png',
            'content': 'Gelb-Rote Karte für ${tickerEntry.teamShowname}',
            'content_detail': tickerEntry.player1Id != null
                ? '${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                : '',
            'content_detail_extra': ''
          };
        }
      case 6:
        {
          return <String, String>{
            'icon_path': livetickerIconsPath + 'red-card.png',
            'content': 'Rote Karte für ${tickerEntry.teamShowname}',
            'content_detail': tickerEntry.player1Id != null
                ? '${tickerEntry.player1Firstname} ${tickerEntry.player1Lastname}'
                : '',
            'content_detail_extra': ''
          };
        }
      default:
        {
          return <String, String>{
            'icon_path': '',
            'content': '',
            'content_detail': '',
            'content_detail_extra': ''
          };
        }
    }
  }

  Future<int> _deleteTickerEntry() async {
    final TickerRemoteDataSource remoteDataSource =
        TickerRemoteDataSourceImpl();
    final TickerRepository tickerRepository =
        TickerRepository(remoteDataSource: remoteDataSource);
    try {
      return await tickerRepository.deleteTickerEntry(tickerEntry.id);
    } on Exception {
      return -1;
    }
  }

  Widget buildDeleteButton(BuildContext context, double width) {
    return SizedBox(
      width: width,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: () async {
          final int id = await _deleteTickerEntry();
          if (id == tickerEntry.id) {
            ScaffoldMessenger.of(context).showSnackBar(GlobalSnackBar(
                text: 'Löschung erfolgreich', successfull: true));
            refreshTicker(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(GlobalSnackBar(
                text: 'Löschung fehlgeschlagen', successfull: false));
          }
        },
        icon: const Icon(
          Icons.clear,
          color: Colors.red,
        ),
      ),
    );
  }
}

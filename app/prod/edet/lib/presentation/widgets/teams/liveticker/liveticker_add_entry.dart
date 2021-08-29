import 'package:edet/constants.dart';
import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_action_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/global/global_snack_bar.dart';
import 'package:edet/presentation/widgets/teams/liveticker/liveticker_add_entry_row.dart';
import 'package:edet/presentation/widgets/teams/liveticker/liveticker_elevated_button.dart';
import 'package:flutter/material.dart';

class LiveTickerAddEntry extends StatefulWidget {
  final Function notifyParent;
  final Future<void> Function(BuildContext context) refreshTicker;
  final List<TickerActionModel> actions;
  final List<PlayerModel> players;
  final MatchModel match;
  final bool isVisible;
  final TickerRemoteDataSource _remoteDataSource = TickerRemoteDataSourceImpl();

  LiveTickerAddEntry({
    Key? key,
    required this.notifyParent,
    required this.refreshTicker,
    required this.actions,
    required this.players,
    required this.match,
    required this.isVisible,
  }) : super(key: key);

  @override
  _LiveTickerAddEntryState createState() => _LiveTickerAddEntryState();
}

class _LiveTickerAddEntryState extends State<LiveTickerAddEntry> {
  static const double inputFieldWidth = 200.0;

  TickerActionModel? _tickerActionDropdownValue;
  Team? _teamDropdownValue;
  dynamic _player1DropdownValue;
  dynamic _player2DropdownValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _minuteFieldController = TextEditingController();
  final _commentFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Visibility(
      visible: widget.isVisible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LiveTickerAddEntryRow(
                description: 'Minute:',
                inputField: buildMinuteField(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: true,
              ),
              LiveTickerAddEntryRow(
                description: 'Aktion:',
                inputField: buildActionsDropdown(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: true,
              ),
              LiveTickerAddEntryRow(
                description: chooseTeamDropdownString(),
                inputField: buildTeamDropdown(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: true,
              ),
              LiveTickerAddEntryRow(
                description: choosePlayerDropdownString()[0] + ':',
                inputField: buildPlayer1Dropdown(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: choosePlayerVisibilites()[0],
              ),
              LiveTickerAddEntryRow(
                description: choosePlayerDropdownString()[1] + ':',
                inputField: buildPlayer2Dropdown(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: choosePlayerVisibilites()[1],
              ),
              LiveTickerAddEntryRow(
                description: 'Kommentar:',
                inputField: buildCommentField(),
                inputFieldWith: inputFieldWidth,
                screenWidth: screenSize.width,
                isVisible: true,
              ),
              buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMinuteField() {
    return SizedBox(
      width: inputFieldWidth,
      child: TextFormField(
        controller: _minuteFieldController,
        cursorColor: blackBackgroundColor,
        autofocus: true,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: blackBackgroundColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: blackBackgroundColor),
          ),
        ),
        validator: (String? value) {
          bool isInt = true;
          try {
            int.parse(value.toString());
          } on Exception {
            isInt = false;
          }

          if (value == null || value.isEmpty || !isInt) {
            return 'Bitte Minute (z.B. 35) eingeben.';
          }
          return null;
        },
      ),
    );
  }

  Widget buildActionsDropdown() {
    List<DropdownMenuItem<TickerActionModel>> items = widget.actions
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e.actionName),
            ))
        .toList();

    return SizedBox(
      width: inputFieldWidth,
      child: DropdownButton(
        onTap: () => FocusScope.of(context).unfocus(),
        autofocus: true,
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        items: items,
        hint: _tickerActionDropdownValue != null
            ? Text(
                _tickerActionDropdownValue!.actionName,
                style: const TextStyle(color: Colors.black),
              )
            : const Text('Aktion'),
        onChanged: (TickerActionModel? val) {
          setState(() {
            _tickerActionDropdownValue = val;
          });
        },
      ),
    );
  }

  Widget buildTeamDropdown() {
    Team homeTeam = Team(
        id: widget.match.homeTeamId, showname: widget.match.homeTeamShowname);
    Team awayTeam = Team(
        id: widget.match.awayTeamId, showname: widget.match.awayTeamShowname);

    List<DropdownMenuItem<Team>> items = [
      DropdownMenuItem(value: homeTeam, child: Text(homeTeam.showname)),
      DropdownMenuItem(value: awayTeam, child: Text(awayTeam.showname))
    ];

    return SizedBox(
      width: inputFieldWidth,
      child: DropdownButton(
        onTap: () => FocusScope.of(context).unfocus(),
        style: const TextStyle(color: Colors.black),
        isExpanded: true,
        items: items,
        hint: _teamDropdownValue != null
            ? Text(
                _teamDropdownValue!.showname,
                style: const TextStyle(color: Colors.black),
              )
            : const Text('Team'),
        onChanged: (Team? val) {
          setState(() {
            _teamDropdownValue = val;
          });
        },
      ),
    );
  }

  Widget buildPlayer1Dropdown() {
    return SizedBox(
      width: inputFieldWidth,
      child: DropdownButton(
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        items: buildPlayerDropdownItems(),
        hint: _player1DropdownValue != null
            ? Text(
                _player1DropdownValue!.toString(),
                style: const TextStyle(color: Colors.black),
              )
            : Text(choosePlayerDropdownString()[0]),
        onChanged: (dynamic val) {
          setState(() {
            _player1DropdownValue = val;
          });
        },
      ),
    );
  }

  Widget buildPlayer2Dropdown() {
    return SizedBox(
      width: inputFieldWidth,
      child: DropdownButton(
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        items: buildPlayerDropdownItems(),
        hint: _player2DropdownValue != null
            ? Text(
                _player2DropdownValue!.toString(),
                style: const TextStyle(color: Colors.black),
              )
            : Text(choosePlayerDropdownString()[1]),
        onChanged: (dynamic val) {
          setState(() {
            _player2DropdownValue = val;
          });
        },
      ),
    );
  }

  List<bool> choosePlayerVisibilites() {
    if (_teamDropdownValue != null && _tickerActionDropdownValue != null) {
      if (_teamDropdownValue!.showname.contains('Meckenhausen')) {
        if (_tickerActionDropdownValue!.id == 1) {
          return [true, true];
        } else if (_tickerActionDropdownValue!.id == 3) {
          return [true, true];
        } else if (_tickerActionDropdownValue!.id != 2) {
          return [true, false];
        }
      }
    }
    return [false, false];
  }

  List<String> choosePlayerDropdownString() {
    if (_tickerActionDropdownValue != null) {
      if (_tickerActionDropdownValue!.id == 1 ||
          _tickerActionDropdownValue!.id == 2) {
        return ['Torschütze', 'Vorlage'];
      } else if (_tickerActionDropdownValue!.id == 3) {
        return ['Auswechslung', 'Einwechslung'];
      } else {
        return ['Spieler', ''];
      }
    }
    return ['', ''];
  }

  String chooseTeamDropdownString() {
    if (_tickerActionDropdownValue != null) {
      if (_tickerActionDropdownValue!.id == 2) {
        return 'Eigentor von:';
      }
    }
    return 'Team:';
  }

  Widget buildCommentField() {
    return SizedBox(
      width: inputFieldWidth,
      child: TextField(
        controller: _commentFieldController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: blackBackgroundColor,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blackBackgroundColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: blackBackgroundColor),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<dynamic>> buildPlayerDropdownItems() {
    List<DropdownMenuItem<dynamic>> items = [
      const DropdownMenuItem(value: 'keine Angabe', child: Text('keine Angabe'))
    ];
    for (var player in widget.players) {
      items.add(
        DropdownMenuItem(
          value: player,
          child: Text(
            player.toString(),
          ),
        ),
      );
    }
    return items;
  }

  int? checkPlayerDropdownValue(dynamic value) {
    return value != null
        ? value.toString() != 'keine Angabe'
            ? value.id
            : null
        : null;
  }

//needed because OwnGoal is inverted
  Team chooseTeamOnActionId() {
    if (_tickerActionDropdownValue!.id == 2) {
      if (widget.match.homeTeamId == _teamDropdownValue!.id) {
        return Team(
            id: widget.match.awayTeamId,
            showname: widget.match.awayTeamShowname);
      } else {
        return Team(
            id: widget.match.homeTeamId,
            showname: widget.match.homeTeamShowname);
      }
    }
    return Team(
        id: _teamDropdownValue!.id, showname: _teamDropdownValue!.showname);
  }

  Future<int> sendTickerEntry() async {
    final int minute = int.parse(_minuteFieldController.text);
    final int actionId = _tickerActionDropdownValue!.id;
    final String action = _tickerActionDropdownValue!.actionName;
    final int teamId = chooseTeamOnActionId().id;
    final String teamShowname = chooseTeamOnActionId().showname;
    final int? player1Id = checkPlayerDropdownValue(_player1DropdownValue);
    final int? player2Id = checkPlayerDropdownValue(_player2DropdownValue);
    final String? comment = _commentFieldController.text;
    final int matchId = widget.match.id;

    final TickerModel tickerEntry = TickerModel(
      id: -1,
      minute: minute,
      actionId: actionId,
      action: action,
      teamId: teamId,
      teamShowname: teamShowname,
      player1Id: player1Id,
      player2Id: player2Id,
      comment: comment,
      matchId: matchId,
    );

    final TickerRepository _tickerRepository =
        TickerRepository(remoteDataSource: widget._remoteDataSource);
    try {
      return await _tickerRepository.addTickerEntry(tickerEntry);
    } on Exception {
      return -1;
    }
  }

  void _confirmEntries() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate() &&
          _tickerActionDropdownValue != null &&
          _teamDropdownValue != null) {
        final id = await sendTickerEntry();
        if (id != -1) {
          ScaffoldMessenger.of(context).showSnackBar(
              GlobalSnackBar(text: 'Eintrag erfolgreich', successfull: true));
          widget.refreshTicker(context);
          widget.notifyParent(false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(GlobalSnackBar(
              text: 'Eintrag fehlgeschlagen', successfull: false));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            GlobalSnackBar(text: 'Eintrag fehlgeschlagen', successfull: false));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          GlobalSnackBar(text: 'Eintrag fehlgeschlagen', successfull: false));
    }
  }

  Widget buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: LiveTickerElevatedButton(
        text: 'Bestätigen',
        onPressed: _confirmEntries,
      ),
    );
  }
}

class Team {
  final int id;
  final String showname;

  Team({
    required this.id,
    required this.showname,
  });
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';
import 'package:edet/data/datasources/http_functions.dart';

abstract class FupaRemoteDataSource {
  final String teamname;
  final String teamclass;
  final String teamseason;

  FupaRemoteDataSource({
    required this.teamname,
    required this.teamclass,
    required this.teamseason,
  });

  Future<List<PlayerModel>> getPlayers();
  Future<List<MatchModel>> getTeamMatches();
  Future<List<MatchModel>> getLeagueMatches();
  Future<List<StandingsRowModel>> getStandings();
  Future<LeagueModel> getLeague();
}

class FupaRemoteDataSourceImpl implements FupaRemoteDataSource {
  @override
  final String teamname;
  @override
  final String teamclass;
  @override
  final String teamseason;

  final String _authority = 'jb7o2lh1ej.execute-api.eu-central-1.amazonaws.com';
  final String _unencodedPathMain = '/prod';
  Map<String, String> _parameters = {};

  FupaRemoteDataSourceImpl({
    required this.teamname,
    required this.teamclass,
    required this.teamseason,
  }) {
    _parameters = {
      'teamname': teamname,
      'teamclass': teamclass,
      'teamseason': teamseason
    };
  }

  @override
  Future<List<PlayerModel>> getPlayers() async {
    final String _unencodedPath = _unencodedPathMain + '/players';

    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    List<dynamic> players = json.decode(response.body);
    return players.map((player) => PlayerModel.fromJson(player)).toList();
  }

  @override
  Future<List<MatchModel>> getTeamMatches() async {
    final String _unencodedPath = _unencodedPathMain + '/teammatches';
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    return _convertResponseToMatchModels(response);
  }

  @override
  Future<List<MatchModel>> getLeagueMatches() async {
    final String _unencodedPath = _unencodedPathMain + '/leaguematches';
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    return _convertResponseToMatchModels(response);
  }

  @override
  Future<List<StandingsRowModel>> getStandings() async {
    final String _unencodedPath = _unencodedPathMain + '/standings';
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    List<dynamic> standingsRows = json.decode(response.body);
    return standingsRows.map((row) => StandingsRowModel.fromJson(row)).toList();
  }

  @override
  Future<LeagueModel> getLeague() async {
    final String _unencodedPath = _unencodedPathMain + '/mainleague';
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    return LeagueModel.fromJson(json.decode(response.body));
  }

  List<MatchModel> _convertResponseToMatchModels(http.Response response) {
    List<dynamic> matches = json.decode(response.body);
    return matches.map((match) => MatchModel.fromJson(match)).toList();
  }
}

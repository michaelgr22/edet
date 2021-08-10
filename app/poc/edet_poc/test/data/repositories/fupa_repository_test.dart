import 'dart:convert';

import 'package:edet_poc/data/datasources/fupa_remote_datasource.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/data/repositories/fupa_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const playersRaw =
    '[{"player_id": 129, "player_firstname": "Niklas", "player_lastname": "Beck", "player_birthday": "2002-02-23 00:00:00", "player_deployments": 1, "player_goals": 0, "player_position": "Abwehr", "player_imagelink": "https://image.fupa.net/player/GZhpOxpPpyi6/64x80.jpeg"}, {"player_id": 130, "player_firstname": "Andreas", "player_lastname": "Bogner", "player_birthday": "2001-12-11 00:00:00", "player_deployments": 2, "player_goals": 0, "player_position": "Abwehr", "player_imagelink": "https://image.fupa.net/player/VHsvL7ucKe1M/64x80.jpeg"}]';
List<dynamic> players = json.decode(playersRaw);
final playersList =
    players.map((player) => PlayerModel.fromJson(player)).toList();

const matchesRaw =
    '[{"match_id": 1456, "match_date_time": "2021-06-27 14:00:00", "match_home_team_showname": "1. FC Beilngries", "match_away_team_showname": "TSV Meckenhausen", "match_link": "https://www.fupa.net/match/1-fc-beilngries-m1-tsv-meckenhausen-m1-210627", "match_home_goals": 1, "match_away_goals": 0, "match_cancelled": false, "match_league_showname": "Testspiele"}, {"match_id": 1457, "match_date_time": "2021-07-10 15:00:00", "match_home_team_showname": "TSV Meckenhausen", "match_away_team_showname": "SG Pilsach / Litzlohe", "match_link": "https://www.fupa.net/match/tsv-meckenhausen-m1-djksv-pilsach-m1-210710", "match_home_goals": 6, "match_away_goals": 0, "match_cancelled": false, "match_league_showname": "Testspiele"}, {"match_id": 1458, "match_date_time": "2021-07-18 13:00:00", "match_home_team_showname": "TSV Greding", "match_away_team_showname": "TSV Meckenhausen", "match_link": "https://www.fupa.net/match/tsv-greding-m1-tsv-meckenhausen-m1-210718_2", "match_home_goals": 1, "match_away_goals": 4, "match_cancelled": false, "match_league_showname": "Testspiele"}]';
List<dynamic> matches = json.decode(matchesRaw);
final matchesList = matches.map((match) => MatchModel.fromJson(match)).toList();

const standingsRaw =
    '[{"standings_id": 825, "standings_position": 1, "standings_team_showname": "TSV Wolfstein", "standings_games": 2, "standings_wins": 2, "standings_draws": 0, "standings_loses": 0, "standings_goals": 9, "standings_countered_goals": 2, "standings_points": 6}, {"standings_id": 821, "standings_position": 2, "standings_team_showname": "TSV Meckenhausen", "standings_games": 2, "standings_wins": 2, "standings_draws": 0, "standings_loses": 0, "standings_goals": 7, "standings_countered_goals": 2, "standings_points": 6}, {"standings_id": 818, "standings_position": 3, "standings_team_showname": "DJK-SV Berg", "standings_games": 2, "standings_wins": 2, "standings_draws": 0, "standings_loses": 0, "standings_goals": 5, "standings_countered_goals": 1, "standings_points": 6}]';
List<dynamic> standings = json.decode(standingsRaw);
final standingsList =
    standings.map((row) => StandingsRowModel.fromJson(row)).toList();

const leagueRaw =
    '{"league_id": 1516, "league_showname": "Kreisliga Neumarkt/Jura Ost", "league_name": "kreisliga-neumarkt-jura-ost", "league_season": "2021-22"}';
final league = LeagueModel.fromJson(json.decode(leagueRaw));

class MockFupaRemoteDataSource extends Mock implements FupaRemoteDataSource {
  @override
  Future<List<PlayerModel>> getPlayers() {
    return Future.delayed(const Duration(seconds: 1), () => playersList);
  }

  @override
  Future<List<MatchModel>> getTeamMatches() {
    return Future.delayed(const Duration(seconds: 1), () => matchesList);
  }

  @override
  Future<List<MatchModel>> getLeagueMatches() {
    return Future.delayed(const Duration(seconds: 1), () => matchesList);
  }

  @override
  Future<List<StandingsRowModel>> getStandings() {
    return Future.delayed(const Duration(seconds: 1), () => standingsList);
  }

  @override
  Future<LeagueModel> getLeague() {
    return Future.delayed(const Duration(seconds: 1), () => league);
  }
}

void main() {
  final MockFupaRemoteDataSource remoteDataSource = MockFupaRemoteDataSource();
  final fupaRepository = FupaRepository(remoteDataSource: remoteDataSource);
  test(
      'should return List of Players when getPlayers is called and RemoteDataSoucre is working',
      () async {
    //arrange
    //act
    //assert
    expect(await fupaRepository.getPlayers(), isA<List<PlayerModel>>());
  });

  test(
      'should return List of Matches when getTeamMatches is called and RemoteDataSoucre is working',
      () async {
    //arrange
    //act
    //assert
    expect(await fupaRepository.getTeamMatches(), isA<List<MatchModel>>());
  });

  test(
      'should return List of Matches when getLeagueMatches is called and RemoteDataSoucre is working',
      () async {
    //arrange
    //act
    //assert
    expect(await fupaRepository.getLeagueMatches(), isA<List<MatchModel>>());
  });

  test(
      'should return List of StandingsRows when getStandings is called and RemoteDataSoucre is working',
      () async {
    //arrange
    //act
    //assert
    expect(await fupaRepository.getStandings(), isA<List<StandingsRowModel>>());
  });

  test(
      'should return League when getLeague is called and RemoteDataSoucre is working',
      () async {
    //arrange
    //act
    //assert
    expect(await fupaRepository.getLeague(), isA<LeagueModel>());
  });
}

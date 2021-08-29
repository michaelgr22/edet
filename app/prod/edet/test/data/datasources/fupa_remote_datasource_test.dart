import 'package:flutter_test/flutter_test.dart';

import 'package:edet/data/datasources/fupa_remote_datasource.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';

void main() {
  final remoteDataSource = FupaRemoteDataSourceImpl(
      teamname: 'tsv-meckenhausen', teamclass: 'm1', teamseason: '2021-22');
  test('should return List of PlayerModels when getPlayers is called',
      () async {
    //arrange
    //act
    final players = await remoteDataSource.getPlayers();
    //assert
    expect(players, isA<List<PlayerModel>>());
  });

  test('should return List of MatchesModels when getTeamMatches is called',
      () async {
    //arrange
    //act
    final matches = await remoteDataSource.getTeamMatches();
    //assert
    expect(matches, isA<List<MatchModel>>());
  });

  test('should return List of MatchesModels when getLeagueMatches is called',
      () async {
    //arrange
    //act
    final matches = await remoteDataSource.getLeagueMatches();
    //assert
    expect(matches, isA<List<MatchModel>>());
  });

  test('should return List of StandingsRowModels when getStandings is called',
      () async {
    //arrange
    //act
    final standings = await remoteDataSource.getStandings();
    //assert
    expect(standings, isA<List<StandingsRowModel>>());
  });

  test('should return a LeagueModel when getLeague is called', () async {
    //arrange
    //act
    final league = await remoteDataSource.getLeague();
    //assert
    expect(league, isA<LeagueModel>());
  });
}

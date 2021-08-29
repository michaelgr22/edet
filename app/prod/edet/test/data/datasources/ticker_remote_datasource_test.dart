import 'dart:io';

import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/models/ticker_action_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> tickerJson = {
  'ticker_id': 1,
  'ticker_minute': 1,
  'action_id': 1,
  'action_name': 'Tor',
  'team_id': 3754,
  'team_showname': 'TSV Meckenhausen',
  'ticker_player1_id': 105,
  'player1_firstname': 'Valentin',
  'player1_lastname': 'Körner',
  'ticker_player2_id': null,
  'player2_firstname': null,
  'player2_lastname': null,
  'ticker_comment': 'TOOOOR',
  'ticker_match_id': 1417
};

void main() {
  final remoteDataSource = TickerRemoteDataSourceImpl();
  final tickerModel = TickerModel.fromJson(tickerJson);

  test('should return List of TickerEntries when getTicker is called',
      () async {
    //arrange
    int matchId = 1463;
    //act
    final tickerEntries = await remoteDataSource.getTicker(matchId);
    //assert
    expect(tickerEntries, isA<List<TickerModel>>());
  });

  test('should return List of TickerActions when getTickerActions is called',
      () async {
    //arrange
    //act
    final tickerActions = await remoteDataSource.getTickerActions();
    //assert
    expect(tickerActions, isA<List<TickerActionModel>>());
  });

  test(
      'should add/delete TickerEntry when addTickerEntry/deleteTickerEntry is called',
      () async {
    //arrange
    //act
    final idAdded = await remoteDataSource.addTickerEntry(tickerModel);
    //assert
    expect(idAdded, isA<int>());

    sleep(const Duration(seconds: 1));
    //act
    final idDeleted = await remoteDataSource.deleteTickerEntry(idAdded);
    //assert
    expect(idDeleted, isA<int>());
  });
}

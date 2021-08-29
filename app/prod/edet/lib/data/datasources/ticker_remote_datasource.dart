import 'dart:convert';
import 'package:edet/data/models/ticker_action_model.dart';
import 'package:http/http.dart' as http;

import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/datasources/http_functions.dart';

abstract class TickerRemoteDataSource {
  Future<List<TickerModel>> getTicker(int matchId);
  Future<List<TickerActionModel>> getTickerActions();
  Future<int> addTickerEntry(TickerModel tickerEntry);
  Future<int> deleteTickerEntry(int tickerId);
}

class TickerRemoteDataSourceImpl implements TickerRemoteDataSource {
  final String _authority = 'jb7o2lh1ej.execute-api.eu-central-1.amazonaws.com';
  final String _unencodedPathMain = '/prod';
  Map<String, String> _parameters = {};

  @override
  Future<List<TickerModel>> getTicker(int matchId) async {
    final String _unencodedPath = _unencodedPathMain + '/ticker';

    _parameters = {'match_id': matchId.toString()};

    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    List<dynamic> tickerEntries = json.decode(response.body);
    return tickerEntries.map((entry) => TickerModel.fromJson(entry)).toList();
  }

  @override
  Future<List<TickerActionModel>> getTickerActions() async {
    final String _unencodedPath = _unencodedPathMain + '/ticker/actions';

    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    List<dynamic> tickerActions = json.decode(response.body);
    return tickerActions
        .map((action) => TickerActionModel.fromJson(action))
        .toList();
  }

  @override
  Future<int> deleteTickerEntry(int tickerId) async {
    final String _unencodedPath = _unencodedPathMain + '/ticker/delete';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {'ticker_id': tickerId};
    final http.Response response = await sendPostRequest(
        _authority, _unencodedPath, _parameters, headers, body);
    return json.decode(response.body)['ticker_id'];
  }

  @override
  Future<int> addTickerEntry(TickerModel tickerEntry) async {
    final String _unencodedPath = _unencodedPathMain + '/ticker/add';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final http.Response response = await sendPostRequest(
        _authority,
        _unencodedPath,
        _parameters,
        headers,
        tickerEntry.toJsonForApi(tickerEntry));

    return json.decode(response.body)['ticker_id'];
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:edet_poc/data/models/news_model.dart';
import 'package:edet_poc/core/errors/exceptions.dart';

abstract class MckRemoteDataSource {
  Future<List<NewsModel>> getNews();
  Future<NewsModel> getNewsItemfromId(int id);
}

class MckRemoteDataSourceImpl implements MckRemoteDataSource {
  final String _authority = 'jb7o2lh1ej.execute-api.eu-central-1.amazonaws.com';
  final String _unencodedPath = '/dev/mcknews';
  Map<String, String> _parameters = {};

  @override
  Future<List<NewsModel>> getNews() async {
    final http.Response response = await _sendGetRequest();
    return _convertResponseToModels(response);
  }

  @override
  Future<NewsModel> getNewsItemfromId(int id) async {
    _parameters = {'id': id.toString()};
    final http.Response response = await _sendGetRequest();
    return NewsModel.fromJson(json.decode(response.body));
  }

  Future<http.Response> _sendGetRequest() async {
    final Uri url = Uri.https(_authority, _unencodedPath, _parameters);
    try {
      final response = await http.get(url);
      return response;
    } on Exception {
      throw NetworkException();
    }
  }

  List<NewsModel> _convertResponseToModels(http.Response response) {
    List<NewsModel> models = [];

    json.decode(response.body).forEach((news) {
      models.add(NewsModel.fromJson(news));
    });

    return models;
  }
}

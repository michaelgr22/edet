import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:edet/data/models/news_model.dart';
import 'package:edet/data/datasources/http_functions.dart';

abstract class MckRemoteDataSource {
  Future<List<NewsModel>> getNews();
  Future<NewsModel> getNewsItemfromId(int id);
}

class MckRemoteDataSourceImpl implements MckRemoteDataSource {
  final String _authority = 'jb7o2lh1ej.execute-api.eu-central-1.amazonaws.com';
  final String _unencodedPath = '/prod/mcknews';
  Map<String, String> _parameters = {};

  @override
  Future<List<NewsModel>> getNews() async {
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    return _convertResponseToModels(response);
  }

  @override
  Future<NewsModel> getNewsItemfromId(int id) async {
    _parameters = {'id': id.toString()};
    final http.Response response =
        await sendGetRequest(_authority, _unencodedPath, _parameters);
    return NewsModel.fromJson(json.decode(response.body));
  }

  List<NewsModel> _convertResponseToModels(http.Response response) {
    List<NewsModel> models = [];

    json.decode(response.body).forEach((news) {
      models.add(NewsModel.fromJson(news));
    });

    return models;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:edet_poc/data/models/news_model.dart';
import 'package:edet_poc/core/errors/exceptions.dart';

abstract class MckRemoteDataSource {
  Future<List<NewsModel>> getNews();
}

class MckRemoteDataSourceImpl implements MckRemoteDataSource {
  final String _authority = 'jb7o2lh1ej.execute-api.eu-central-1.amazonaws.com';
  final String _unencodedPath = '/dev/mcknews';
  Map<String, String> parameters = {'number': '5'};

  @override
  Future<List<NewsModel>> getNews() async {
    final Uri url = Uri.https(_authority, _unencodedPath, parameters);

    try {
      final response = await http.get(url);
      return _convertResponseToModels(response);
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

import 'package:flutter_test/flutter_test.dart';

import 'package:edet_poc/data/datasources/mck_remote_datasource.dart';
import 'package:edet_poc/data/models/news_model.dart';

void main() {
  test('should return List of NewsModels when getNews is called', () async {
    //arrange
    final remoteDataSource = MckRemoteDataSourceImpl();
    //act
    final newsList = await remoteDataSource.getNews();
    //assert
    expect(newsList, isA<List<NewsModel>>());
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:edet/data/datasources/mck_remote_datasource.dart';
import 'package:edet/data/models/news_model.dart';

void main() {
  test('should return List of NewsModels when getNews is called', () async {
    //arrange
    final remoteDataSource = MckRemoteDataSourceImpl();
    //act
    final newsList = await remoteDataSource.getNews();
    //assert
    expect(newsList, isA<List<NewsModel>>());
  });

  test('should return NewsModel with id when getNewsItemfromId is called',
      () async {
    //arrange
    final remoteDataSource = MckRemoteDataSourceImpl();
    //act
    final newsItem = await remoteDataSource.getNewsItemfromId(1);
    //assert
    expect(newsItem, isA<NewsModel>());
  });
}

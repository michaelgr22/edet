import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:edet_poc/data/datasources/mck_remote_datasource.dart';
import 'package:edet_poc/data/models/news_model.dart';
import 'package:edet_poc/data/repositories/news_repository.dart';

final newsReturnList = [
  NewsModel(
      headline: 'headline',
      date: DateTime.parse('2021-07-14 00:00:00'),
      category: 'category',
      imagelink: 'imagelink',
      content: 'content'),
  NewsModel(
      headline: 'headline2',
      date: DateTime.parse('2021-07-15 00:00:00'),
      category: 'category2',
      imagelink: 'imagelink2',
      content: 'content2'),
];

class MockMckRemoteDataSource extends Mock implements MckRemoteDataSource {
  @override
  Future<List<NewsModel>> getNews() async {
    return Future.delayed(const Duration(seconds: 1), () => newsReturnList);
  }
}

void main() {
  test(
      'should return List of NewsModels when getNews is called and RemoteDataSoucre is working',
      () async {
    //arrange
    final MockMckRemoteDataSource mckRemoteDataSource =
        MockMckRemoteDataSource();
    final newsRepository =
        NewsRepository(remoteDataSource: mckRemoteDataSource);
    //act
    //assert
    expect(await newsRepository.getNews(), isA<List<NewsModel>>());
  });
}

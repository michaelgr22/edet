import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:edet/data/datasources/mck_remote_datasource.dart';
import 'package:edet/data/models/news_model.dart';
import 'package:edet/data/repositories/news_repository.dart';

final newsReturnList = [
  NewsModel(
      id: 1,
      headline: 'headline',
      date: DateTime.parse('2021-07-14 00:00:00'),
      category: 'category',
      imagelink: 'imagelink',
      content: 'content'),
  NewsModel(
      id: 2,
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

  @override
  Future<NewsModel> getNewsItemfromId(int id) async {
    return Future.delayed(const Duration(seconds: 1), () => newsReturnList[0]);
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

  test(
      'should return NewsModel with id when getNewsItemfromId is called and RemoteDataSoucre is working',
      () async {
    //arrange
    final MockMckRemoteDataSource mckRemoteDataSource =
        MockMckRemoteDataSource();
    final newsRepository =
        NewsRepository(remoteDataSource: mckRemoteDataSource);
    //act
    //assert
    expect(await newsRepository.getNewsItemfromId(1), isA<NewsModel>());
  });
}

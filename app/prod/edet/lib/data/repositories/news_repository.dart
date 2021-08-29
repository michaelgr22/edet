import 'package:edet/data/datasources/mck_remote_datasource.dart';
import 'package:edet/data/models/news_model.dart';

class NewsRepository {
  final MckRemoteDataSource remoteDataSource;

  NewsRepository({required this.remoteDataSource});

  Future<List<NewsModel>> getNews() {
    return remoteDataSource.getNews();
  }

  Future<NewsModel> getNewsItemfromId(int id) {
    return remoteDataSource.getNewsItemfromId(id);
  }
}

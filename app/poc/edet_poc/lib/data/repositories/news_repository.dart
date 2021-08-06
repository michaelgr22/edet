import 'package:edet_poc/data/datasources/mck_remote_datasource.dart';
import 'package:edet_poc/data/models/news_model.dart';

class NewsRepository {
  final MckRemoteDataSource remoteDataSource;

  NewsRepository({required this.remoteDataSource});

  Future<List<NewsModel>> getNews() {
    return remoteDataSource.getNews();
  }
}

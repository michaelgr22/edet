part of 'news_cubit.dart';

@immutable
abstract class NewsState {
  const NewsState();
}

class NewsStateInitial extends NewsState {
  const NewsStateInitial();
}

class NewsStateLoaded extends NewsState {
  final List<NewsModel> news;
  const NewsStateLoaded(this.news);
}

class NewsStateLoading extends NewsState {
  const NewsStateLoading();
}

class NewsStateError extends NewsState {
  final String message;
  const NewsStateError(this.message);
}

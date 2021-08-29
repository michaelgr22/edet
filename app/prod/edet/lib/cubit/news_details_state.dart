part of 'news_details_cubit.dart';

@immutable
abstract class NewsDetailsState {
  const NewsDetailsState();
}

class NewsDetailsStateInitial extends NewsDetailsState {
  const NewsDetailsStateInitial();
}

class NewsDetailsStateLoaded extends NewsDetailsState {
  final NewsModel newsItem;
  const NewsDetailsStateLoaded(this.newsItem);
}

class NewsDetailsStateLoading extends NewsDetailsState {
  const NewsDetailsStateLoading();
}

class NewsDetailsStateError extends NewsDetailsState {
  final String message;
  const NewsDetailsStateError(this.message);
}

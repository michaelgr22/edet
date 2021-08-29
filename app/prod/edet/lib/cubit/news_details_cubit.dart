import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/news_model.dart';
import 'package:edet/data/repositories/news_repository.dart';
import 'package:meta/meta.dart';

part 'news_details_state.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  final NewsRepository _newsRepository;
  NewsDetailsCubit(this._newsRepository)
      : super(const NewsDetailsStateInitial());

  Future<void> getNewsItemfromId(int id) async {
    try {
      emit(const NewsDetailsStateLoading());
      final newsItem = await _newsRepository.getNewsItemfromId(id);
      emit(NewsDetailsStateLoaded(newsItem));
    } on NetworkException {
      emit(const NewsDetailsStateError("Couldn't fetch data. Device online?"));
    }
    ;
  }
}

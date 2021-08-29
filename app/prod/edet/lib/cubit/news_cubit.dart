import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/repositories/news_repository.dart';
import 'package:meta/meta.dart';
import 'package:edet/data/models/news_model.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;

  NewsCubit(this._newsRepository) : super(const NewsStateInitial());

  Future<void> getNews() async {
    try {
      emit(const NewsStateLoading());
      final news = await _newsRepository.getNews();
      emit(NewsStateLoaded(news));
    } on NetworkException {
      emit(const NewsStateError("Couldn't fetch data. Device online?"));
    }
  }
}

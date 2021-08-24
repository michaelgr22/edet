import 'package:bloc/bloc.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/data/models/ticker_action_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/data/repositories/ticker_repository.dart';
import 'package:meta/meta.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  final TickerRepository _tickerRepository;
  TickerCubit(this._tickerRepository) : super(const TickerStateInitial());

  Future<void> getTicker(int matchId) async {
    try {
      emit(const TickerStateLoading());
      final tickerEntries = await _tickerRepository.getTicker(matchId);
      final tickerActions = await _tickerRepository.getTickerActions();

      emit(TickerStateLoaded(
        tickerEntries: tickerEntries,
        tickerActions: tickerActions,
      ));
    } on NetworkException {
      emit(const TickerStateError("Couldn't fetch data. Device online?"));
    }
  }
}

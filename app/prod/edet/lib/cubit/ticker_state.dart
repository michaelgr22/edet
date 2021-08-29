part of 'ticker_cubit.dart';

@immutable
abstract class TickerState {
  const TickerState();
}

class TickerStateInitial extends TickerState {
  const TickerStateInitial();
}

class TickerStateLoaded extends TickerState {
  final List<TickerModel> tickerEntries;
  final List<TickerActionModel> tickerActions;

  const TickerStateLoaded({
    required this.tickerEntries,
    required this.tickerActions,
  });
}

class TickerStateLoading extends TickerState {
  const TickerStateLoading();
}

class TickerStateError extends TickerState {
  final String message;
  const TickerStateError(this.message);
}

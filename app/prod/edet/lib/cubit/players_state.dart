part of 'players_cubit.dart';

@immutable
abstract class PlayersState {
  const PlayersState();
}

class PlayersStateInitial extends PlayersState {
  const PlayersStateInitial();
}

class PlayersStateLoaded extends PlayersState {
  final List<PlayerModel> players;
  const PlayersStateLoaded(this.players);
}

class PlayersStateLoading extends PlayersState {
  const PlayersStateLoading();
}

class PlayersStateError extends PlayersState {
  final String message;
  const PlayersStateError(this.message);
}

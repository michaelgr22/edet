import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'players_state.dart';

class PlayersCubit extends Cubit<PlayersState> {
  final FupaRepository _fupaRepository;

  PlayersCubit(this._fupaRepository) : super(const PlayersStateInitial());

  Future<void> getPlayers() async {
    try {
      emit(const PlayersStateLoading());
      final players = await _fupaRepository.getPlayers();
      emit(PlayersStateLoaded(players));
    } on NetworkException {
      emit(const PlayersStateError("Couldn't fetch data. Device online?"));
    }
  }
}

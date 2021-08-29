import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'league_state.dart';

class LeagueCubit extends Cubit<LeagueState> {
  final FupaRepository _fupaRepository;

  LeagueCubit(this._fupaRepository) : super(const LeagueStateInitial());

  Future<void> getTeamMatches() async {
    try {
      emit(const LeagueStateLoading());
      final league = await _fupaRepository.getLeague();
      emit(LeagueStateLoaded(league));
    } on NetworkException {
      emit(const LeagueStateError("Couldn't fetch data. Device online?"));
    }
  }
}

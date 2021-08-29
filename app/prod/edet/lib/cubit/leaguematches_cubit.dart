import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'leaguematches_state.dart';

class LeagueMatchesCubit extends Cubit<LeagueMatchesState> {
  final FupaRepository _fupaRepository;

  LeagueMatchesCubit(this._fupaRepository)
      : super(const LeagueMatchesStateInitial());

  Future<void> getTeamMatches() async {
    try {
      emit(const LeagueMatchesStateLoading());
      final matches = await _fupaRepository.getLeagueMatches();
      emit(LeagueMatchesStateLoaded(matches));
    } on NetworkException {
      emit(
          const LeagueMatchesStateError("Couldn't fetch data. Device online?"));
    }
  }
}

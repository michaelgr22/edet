import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/standings_row_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'standings_state.dart';

class StandingsCubit extends Cubit<StandingsState> {
  final FupaRepository _fupaRepository;

  StandingsCubit(this._fupaRepository) : super(const StandingsStateInitial());

  Future<void> getTeamMatches() async {
    try {
      emit(const StandingsStateLoading());
      final standings = await _fupaRepository.getStandings();
      emit(StandingsStateLoaded(standings));
    } on NetworkException {
      emit(const StandingsStateError("Couldn't fetch data. Device online?"));
    }
  }
}

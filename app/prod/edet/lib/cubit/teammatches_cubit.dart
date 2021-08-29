import 'package:bloc/bloc.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:meta/meta.dart';

part 'teammatches_state.dart';

class TeamMatchesCubit extends Cubit<TeamMatchesState> {
  final FupaRepository _fupaRepository;

  TeamMatchesCubit(this._fupaRepository)
      : super(const TeamMatchesStateInitial());

  Future<void> getTeamMatches() async {
    try {
      emit(const TeamMatchesStateLoading());
      final matches = await _fupaRepository.getTeamMatches();
      emit(TeamMatchesStateLoaded(matches));
    } on NetworkException {
      emit(const TeamMatchesStateError("Couldn't fetch data. Device online?"));
    }
  }
}

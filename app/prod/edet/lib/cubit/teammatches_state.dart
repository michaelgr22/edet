part of 'teammatches_cubit.dart';

@immutable
abstract class TeamMatchesState {
  const TeamMatchesState();
}

class TeamMatchesStateInitial extends TeamMatchesState {
  const TeamMatchesStateInitial();
}

class TeamMatchesStateLoaded extends TeamMatchesState {
  final List<MatchModel> matches;
  const TeamMatchesStateLoaded(this.matches);
}

class TeamMatchesStateLoading extends TeamMatchesState {
  const TeamMatchesStateLoading();
}

class TeamMatchesStateError extends TeamMatchesState {
  final String message;
  const TeamMatchesStateError(this.message);
}

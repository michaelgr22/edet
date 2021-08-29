import 'package:edet/data/datasources/fupa_remote_datasource.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/standings_row_model.dart';

class FupaRepository {
  final FupaRemoteDataSource remoteDataSource;

  FupaRepository({required this.remoteDataSource});

  Future<List<PlayerModel>> getPlayers() {
    return remoteDataSource.getPlayers();
  }

  Future<List<MatchModel>> getTeamMatches() {
    return remoteDataSource.getTeamMatches();
  }

  Future<List<MatchModel>> getLeagueMatches() {
    return remoteDataSource.getLeagueMatches();
  }

  Future<List<StandingsRowModel>> getStandings() {
    return remoteDataSource.getStandings();
  }

  Future<LeagueModel> getLeague() {
    return remoteDataSource.getLeague();
  }
}

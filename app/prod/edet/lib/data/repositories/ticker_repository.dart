import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/models/ticker_action_model.dart';
import 'package:edet/data/models/ticker_model.dart';

class TickerRepository {
  final TickerRemoteDataSource remoteDataSource;

  TickerRepository({
    required this.remoteDataSource,
  });

  Future<List<TickerModel>> getTicker(int matchId) {
    return remoteDataSource.getTicker(matchId);
  }

  Future<List<TickerActionModel>> getTickerActions() {
    return remoteDataSource.getTickerActions();
  }

  Future<int> addTickerEntry(TickerModel tickerEntry) {
    return remoteDataSource.addTickerEntry(tickerEntry);
  }

  Future<int> deleteTickerEntry(int tickerId) {
    return remoteDataSource.deleteTickerEntry(tickerId);
  }
}

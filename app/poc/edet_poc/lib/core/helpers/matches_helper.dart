import 'package:edet_poc/data/models/match_model.dart';

class MatchesHelper {
  static List<MatchModel> findMatchesOnThisDay(List<MatchModel> matches) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    return matches
        .where((match) =>
            today ==
            DateTime(
                match.dateTime.year, match.dateTime.month, match.dateTime.day))
        .toList();
  }
}

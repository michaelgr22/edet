class MatchModel {
  final int id;
  final DateTime dateTime;
  final int homeTeamId;
  final String homeTeamImagelink;
  final String homeTeamShowname;
  final int awayTeamId;
  final String awayTeamImagelink;
  final String awayTeamShowname;
  final String link;
  final int homeGoals;
  final int awayGoals;
  final bool cancelled;
  final String leagueShowname;

  MatchModel({
    required this.id,
    required this.dateTime,
    required this.homeTeamId,
    required this.homeTeamImagelink,
    required this.homeTeamShowname,
    required this.awayTeamId,
    required this.awayTeamImagelink,
    required this.awayTeamShowname,
    required this.link,
    required this.homeGoals,
    required this.awayGoals,
    required this.cancelled,
    required this.leagueShowname,
  });

  MatchModel.fromJson(Map<String, dynamic> json)
      : id = json['match_id'],
        dateTime = DateTime.parse(json['match_date_time'] + 'Z').toLocal(),
        homeTeamId = json['match_home_team_id'],
        homeTeamImagelink = json['match_home_image_link'],
        homeTeamShowname = json['match_home_team_showname'],
        awayTeamId = json['match_away_team_id'],
        awayTeamImagelink = json['match_away_image_link'],
        awayTeamShowname = json['match_away_team_showname'],
        link = json['match_link'],
        homeGoals = json['match_home_goals'] ?? -1,
        awayGoals = json['match_away_goals'] ?? -1,
        cancelled = json['match_cancelled'],
        leagueShowname = json['match_league_showname'] != 'Testspiele'
            ? json['match_league_showname']
            : 'Testspiel';

  bool isLivetickerTime() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (now.isAfter(dateTime) &&
        today == DateTime(dateTime.year, dateTime.month, dateTime.day)) {
      return true;
    }
    return false;
  }

  bool isLive() {
    final DateTime now = DateTime.now();
    const int gameDurationMinutes = 115;

    if (now.isAfter(dateTime) &&
        now.isBefore(
          dateTime.add(
            const Duration(minutes: gameDurationMinutes),
          ),
        )) {
      return true;
    }
    return false;
  }

  static MatchModel? findCurrentLiveTickerMatch(List<MatchModel> matches) {
    List<MatchModel> liveMatches =
        matches.where((match) => match.isLivetickerTime()).toList();
    return liveMatches.isNotEmpty ? liveMatches.first : null;
  }

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

class MatchModel {
  final int id;
  final DateTime dateTime;
  final String homeTeamShowname;
  final String awayTeamShowname;
  final String link;
  final int homeGoals;
  final int awayGoals;
  final bool cancelled;
  final String leagueShowname;

  MatchModel({
    required this.id,
    required this.dateTime,
    required this.homeTeamShowname,
    required this.awayTeamShowname,
    required this.link,
    required this.homeGoals,
    required this.awayGoals,
    required this.cancelled,
    required this.leagueShowname,
  });

  MatchModel.fromJson(Map<String, dynamic> json)
      : id = json['match_id'],
        dateTime = DateTime.parse(json['match_date_time']),
        homeTeamShowname = json['match_home_team_showname'],
        awayTeamShowname = json['match_away_team_showname'],
        link = json['match_link'],
        homeGoals = json['match_home_goals'] ?? -1,
        awayGoals = json['match_away_goals'] ?? -1,
        cancelled = json['match_cancelled'],
        leagueShowname = json['match_league_showname'];
}

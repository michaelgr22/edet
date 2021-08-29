class LeagueModel {
  final int id;
  final String leagueShowname;
  final String leagueName;
  final String leagueSeason;

  LeagueModel({
    required this.id,
    required this.leagueShowname,
    required this.leagueName,
    required this.leagueSeason,
  });

  LeagueModel.fromJson(Map<String, dynamic> json)
      : id = json['league_id'],
        leagueShowname = json['league_showname'],
        leagueName = json['league_name'],
        leagueSeason = json['league_season'];
}

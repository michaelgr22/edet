class StandingsRowModel {
  final int id;
  final int position;
  final int teamId;
  final String teamImagelink;
  final String teamShowname;
  final int games;
  final int wins;
  final int draws;
  final int loses;
  final int goals;
  final int counteredGoals;
  final int points;

  StandingsRowModel({
    required this.id,
    required this.position,
    required this.teamId,
    required this.teamImagelink,
    required this.teamShowname,
    required this.games,
    required this.wins,
    required this.draws,
    required this.loses,
    required this.goals,
    required this.counteredGoals,
    required this.points,
  });

  StandingsRowModel.fromJson(Map<String, dynamic> json)
      : id = json['standings_id'],
        position = json['standings_position'],
        teamId = json['standings_team_id'],
        teamImagelink = json['standings_team_image_link'],
        teamShowname = json['standings_team_showname'],
        games = json['standings_games'],
        wins = json['standings_wins'],
        draws = json['standings_draws'],
        loses = json['standings_loses'],
        goals = json['standings_goals'],
        counteredGoals = json['standings_countered_goals'],
        points = json['standings_points'];
}

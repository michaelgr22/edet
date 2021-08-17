class TickerModel {
  final int id;
  final DateTime dateTime;
  final int actionId;
  final String action;
  final int teamId;
  final String teamShowname;
  final int player1Id;
  final String player1Firstname;
  final String player1Lastname;
  final int? player2Id;
  final String? player2Firstname;
  final String? player2Lastname;
  final String? comment;
  final int matchId;

  TickerModel({
    required this.id,
    required this.dateTime,
    required this.actionId,
    required this.action,
    required this.teamId,
    required this.teamShowname,
    required this.player1Id,
    required this.player1Firstname,
    required this.player1Lastname,
    this.player2Id,
    this.player2Firstname,
    this.player2Lastname,
    this.comment,
    required this.matchId,
  });

  TickerModel.fromJson(Map<String, dynamic> json)
      : id = json['ticker_id'],
        dateTime = DateTime.parse(json['ticker_date_time'] + 'Z').toLocal(),
        actionId = json['action_id'],
        action = json['action_name'],
        teamId = json['team_id'],
        teamShowname = json['team_showname'],
        player1Id = json['ticker_player1_id'],
        player1Firstname = json['player1_firstname'],
        player1Lastname = json['player1_lastname'],
        player2Id = json['ticker_player2_id'],
        player2Firstname = json['player2_firstname'],
        player2Lastname = json['player2_lastname'],
        comment = json['ticker_comment'],
        matchId = json['ticker_match_id'];

  Map<String, dynamic> toJsonForApi(TickerModel model) {
    return {
      'ticker_date_time': dateTime.toString(),
      'ticker_action_id': actionId,
      'ticker_team_id': teamId,
      'ticker_player1_id': player1Id,
      'ticker_player2_id': player2Id,
      'ticker_comment': comment,
      'ticker_match_id': matchId
    };
  }
}

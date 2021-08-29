class PlayerModel {
  final int id;
  final String? firstname;
  final String? lastname;
  final DateTime? birthday;
  final int? deployments;
  final int? goals;
  final String? position;
  final String? imagelink;

  PlayerModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.birthday,
    required this.deployments,
    required this.goals,
    required this.position,
    required this.imagelink,
  });

  PlayerModel.fromJson(Map<String, dynamic> json)
      : id = json['player_id'],
        firstname = json['player_firstname'] ?? " ",
        lastname = json['player_lastname'] ?? " ",
        birthday = json['player_birthday'] != null
            ? DateTime.parse(json['player_birthday'])
            : null,
        deployments = json['player_deployments'],
        goals = json['player_goals'],
        position = json['player_position'],
        imagelink = json['player_imagelink'];

  @override
  String toString() {
    return '$firstname $lastname';
  }
}

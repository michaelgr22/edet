class TickerActionModel {
  final int id;
  final String actionName;

  TickerActionModel({
    required this.id,
    required this.actionName,
  });

  TickerActionModel.fromJson(Map<String, dynamic> json)
      : id = json['action_id'],
        actionName = json['action_name'];
}

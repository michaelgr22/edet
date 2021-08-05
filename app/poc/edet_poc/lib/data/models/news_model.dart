class NewsModel {
  final String headline;
  final DateTime date;
  final String category;
  final String imagelink;
  final String content;

  NewsModel({
    required this.headline,
    required this.date,
    required this.category,
    required this.imagelink,
    required this.content,
  });

  NewsModel.fromJson(Map<String, dynamic> json)
      : headline = json['news_headline'],
        date = DateTime.parse(json['news_date']),
        category = json['news_category'],
        imagelink = json['news_imagelink'],
        content = json['news_content'];
}

import 'package:edet_poc/data/models/news_model.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class NewsDetailsPage extends StatelessWidget {
  final int newsId;
  NewsDetailsPage({required this.newsId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("$newsId"),
    );
  }
}

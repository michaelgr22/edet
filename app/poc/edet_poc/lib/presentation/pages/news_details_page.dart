import 'package:flutter/material.dart';

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/news_model.dart';

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

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/data/models/news_model.dart';
import 'package:flutter/material.dart';

class NewsListView extends StatelessWidget {
  final List<NewsModel> news;

  NewsListView({required this.news});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView.builder(
        itemCount: news.length,
        itemBuilder: (c, index) {
          return NewsListViewCard(
            newsItem: news[index],
          );
        },
      ),
    );
    ;
  }
}

class NewsListViewCard extends StatelessWidget {
  final NewsModel newsItem;

  NewsListViewCard({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/news/${newsItem.id}');
        },
        child: Container(
          width: double.infinity,
          height: 80.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    newsItem.imagelink,
                    width: 100,
                    height: 80,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  newsItem.headline,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

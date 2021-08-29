import 'package:flutter/material.dart';

import 'package:edet/constants.dart';
import 'package:edet/data/models/news_model.dart';

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
                child: NewsListViewCardImage(
                  imagelink: newsItem.imagelink,
                ),
              ),
              NewsListViewCardHeadline(headline: newsItem.headline)
            ],
          ),
        ),
      ),
    );
  }
}

class NewsListViewCardImage extends StatelessWidget {
  final String? imagelink;
  static const double width = 100.0;
  static const double height = 80.0;
  static const String placeholderImagePath =
      'assets/images/news_placeholder_image.png';

  NewsListViewCardImage({required this.imagelink});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: buildImage(),
    );
  }

  Widget buildImage() {
    Widget errorImage = Image.asset(
      placeholderImagePath,
      width: width,
      height: height,
    );

    if (imagelink != null) {
      return Image.network(
        imagelink!,
        width: width,
        height: height,
        errorBuilder: (context, error, stacktrace) => errorImage,
      );
    } else {
      return errorImage;
    }
  }
}

class NewsListViewCardHeadline extends StatelessWidget {
  final String headline;
  NewsListViewCardHeadline({required this.headline});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        headline,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

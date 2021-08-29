import 'package:edet/constants.dart';
import 'package:edet/data/models/news_model.dart';
import 'package:edet/presentation/pages/news_details_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class NewsDetails extends StatelessWidget {
  final NewsModel newsItem;

  NewsDetails({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NewsDetailsHeadline(
          headline: newsItem.headline,
        ),
        NewsDetailsDate(date: newsItem.date),
        NewsDetailsImage(imagelink: newsItem.imagelink),
        NewsDetailsContent(content: newsItem.content),
      ],
    );
  }
}

class NewsDetailsHeadline extends StatelessWidget {
  final String headline;
  NewsDetailsHeadline({required this.headline});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Text(
        headline,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NewsDetailsDate extends StatelessWidget {
  final DateTime date;
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  NewsDetailsDate({required this.date});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: Text(
          formatter.format(date),
          style: const TextStyle(color: greyTextColor, fontSize: 15.0),
        ),
      ),
    );
  }
}

class NewsDetailsImage extends StatefulWidget {
  final String? imagelink;

  NewsDetailsImage({Key? key, required this.imagelink}) : super(key: key);

  @override
  _NewsDetailsImageState createState() => _NewsDetailsImageState();
}

class _NewsDetailsImageState extends State<NewsDetailsImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.imagelink != null) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailsImagePage(
                imagelink: widget.imagelink!,
              ),
            ),
          );
        },
        child: Hero(
          tag: widget.imagelink!,
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: Image.network(
              widget.imagelink!,
              errorBuilder: (context, error, stacktrace) {
                return const SizedBox(
                  width: 1.0,
                  height: 1.0,
                );
              },
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }
}

class NewsDetailsContent extends StatelessWidget {
  final String content;

  NewsDetailsContent({required this.content});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Html(
        data: content,
        style: {
          'p': Style(color: Colors.black),
        },
      ),
    );
  }
}

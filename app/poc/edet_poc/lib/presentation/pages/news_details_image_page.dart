import 'package:flutter/material.dart';

class NewsDetailsImagePage extends StatefulWidget {
  final String imagelink;
  NewsDetailsImagePage({Key? key, required this.imagelink}) : super(key: key);

  @override
  _NewsDetailsImagePageState createState() => _NewsDetailsImagePageState();
}

class _NewsDetailsImagePageState extends State<NewsDetailsImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: widget.imagelink,
          child: Image.network(widget.imagelink),
        ),
      ),
    );
  }
}

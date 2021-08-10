import 'package:flutter/material.dart';

class NewsDetailsImageScreen extends StatefulWidget {
  final String imagelink;
  NewsDetailsImageScreen({Key? key, required this.imagelink}) : super(key: key);

  @override
  _NewsDetailsImageScreenState createState() => _NewsDetailsImageScreenState();
}

class _NewsDetailsImageScreenState extends State<NewsDetailsImageScreen> {
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

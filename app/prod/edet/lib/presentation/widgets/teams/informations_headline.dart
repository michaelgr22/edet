import 'package:flutter/material.dart';

class InformationsHeadline extends StatelessWidget {
  final String headline;

  const InformationsHeadline({
    Key? key,
    required this.headline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
        child: Text(
          headline,
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

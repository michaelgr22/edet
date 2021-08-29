import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class InformationsPageContainerBoilerplate extends StatelessWidget {
  final Widget child;
  final String? headline;

  const InformationsPageContainerBoilerplate({
    Key? key,
    required this.child,
    this.headline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultContainerPadding,
          right: defaultContainerPadding,
          top: defaultContainerPadding),
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            child: Column(
              children: buildColumn(),
            )),
      ),
    );
  }

  List<Widget> buildColumn() {
    if (headline == null) {
      return [child];
    } else {
      Widget headlineWidget = Text(
        headline.toString(),
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      );
      return [headlineWidget, child];
    }
  }
}

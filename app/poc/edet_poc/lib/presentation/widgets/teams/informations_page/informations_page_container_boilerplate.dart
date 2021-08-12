import 'package:edet_poc/constants.dart';
import 'package:flutter/material.dart';

class InformationsPageContainerBoilerplate extends StatelessWidget {
  final Widget child;

  const InformationsPageContainerBoilerplate({
    Key? key,
    required this.child,
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
          child: child,
        ),
      ),
    );
  }
}

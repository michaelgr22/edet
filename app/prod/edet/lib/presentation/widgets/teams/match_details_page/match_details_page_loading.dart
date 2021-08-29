import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class MatchDetailsPageLoading extends StatelessWidget {
  const MatchDetailsPageLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(defaultContainerPadding),
          child: Container(
            color: Colors.white,
            height: 130.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultContainerPadding),
          child: Container(
            color: Colors.white,
            height: 500.0,
          ),
        )
      ]),
    );
  }
}

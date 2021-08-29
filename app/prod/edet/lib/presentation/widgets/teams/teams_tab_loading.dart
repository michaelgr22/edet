import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class TeamsTabLoading extends StatelessWidget {
  const TeamsTabLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: greyBackgroundColor,
      child: ListView(
        children: [
          buildContainer(),
          buildContainer(),
          buildContainer(),
        ],
      ),
    );
  }

  Widget buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(defaultContainerPadding),
      child: Container(
        color: Colors.white,
        height: 350.0,
      ),
    );
  }
}

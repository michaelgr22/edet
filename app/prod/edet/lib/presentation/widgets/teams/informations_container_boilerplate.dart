import 'package:flutter/material.dart';

class InformationsContainerBoilerplate extends StatelessWidget {
  final List<Widget> children;

  const InformationsContainerBoilerplate({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
        child: Column(children: children),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  final double height;
  const RowDivider({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: Colors.black,
    );
  }
}

import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class LiveTickerElevatedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const LiveTickerElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: blackBackgroundColor, onPrimary: yellowTextColor),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}

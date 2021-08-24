import 'package:flutter/material.dart';

class GlobalSnackBar extends SnackBar {
  final String text;
  final bool successfull;

  GlobalSnackBar({
    required this.text,
    required this.successfull,
  }) : super(
          backgroundColor: successfull ? Colors.green : Colors.red,
          content: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        );
}

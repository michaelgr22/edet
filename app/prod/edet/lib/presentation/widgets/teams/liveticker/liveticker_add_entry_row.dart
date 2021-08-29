import 'package:edet/constants.dart';
import 'package:flutter/material.dart';

class LiveTickerAddEntryRow extends StatelessWidget {
  final String description;
  final Widget inputField;
  final double inputFieldWith;
  final double screenWidth;
  final bool isVisible;

  const LiveTickerAddEntryRow({
    Key? key,
    required this.description,
    required this.inputField,
    required this.inputFieldWith,
    required this.screenWidth,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double padding = 10.0;
    return Visibility(
      visible: isVisible,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: padding,
              bottom: padding,
            ),
            child: SizedBox(
              width: screenWidth -
                  defaultContainerPadding * 2 -
                  padding * 2 -
                  inputFieldWith,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          inputField
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'constants.dart';

class App extends StatelessWidget {
  static const String _title = 'edet';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme:
            Theme.of(context).textTheme.apply(bodyColor: yellowTextColor),
      ),
      home: HomePage(),
    );
  }
}

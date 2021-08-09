import 'package:flutter/material.dart';

import 'package:edet_poc/presentation/pages/home_page.dart';
import 'package:edet_poc/presentation/pages/news_details_page.dart';
import 'package:edet_poc/constants.dart';
import 'package:edet_poc/core/errors/exceptions.dart';

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
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    final String id = settings.name!.split('/').last;
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      );
    } else if (settings.name!.startsWith('/news')) {
      return MaterialPageRoute(
        builder: (context) {
          return NewsDetailsPage(
            newsId: int.parse(id),
          );
        },
      );
    } else {
      throw UndefiniedRouteException();
    }
  }
}

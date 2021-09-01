import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'package:edet/presentation/pages/home_page.dart';
import 'package:edet/presentation/pages/news_details_page.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

class App extends StatelessWidget {
  static const String _title = 'edet';
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

import 'package:edet_poc/presentation/widgets/news/news_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/cubit/news_details_cubit.dart';
import 'package:edet_poc/data/datasources/mck_remote_datasource.dart';
import 'package:edet_poc/data/repositories/news_repository.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';

class NewsDetailsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final _mckRemoteDataSource = MckRemoteDataSourceImpl();
  final int newsId;
  NewsDetailsPage({required this.newsId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(submenuAppBarSize),
        child: GlobalAppBar(
          tabs: _tabs,
          showTabBar: false,
        ),
      ),
      body: BlocProvider(
        create: (_) => NewsDetailsCubit(
            NewsRepository(remoteDataSource: _mckRemoteDataSource))
          ..getNewsItemfromId(newsId),
        child: BlocBuilder<NewsDetailsCubit, NewsDetailsState>(
          builder: (context, state) {
            return stateManager(state);
          },
        ),
      ),
    );
  }

  Widget stateManager(NewsDetailsState state) {
    if (state is NewsDetailsStateInitial || state is NewsDetailsStateLoading) {
      return buildNewsDetailsLoading();
    } else if (state is NewsDetailsStateLoaded) {
      return NewsDetails(newsItem: state.newsItem);
    } else if (state is NewsDetailsStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }

  Widget buildNewsDetailsLoading() {
    return ListView(
      children: [
        Container(
          height: 2000,
          color: Colors.white,
        )
      ],
    );
  }
}

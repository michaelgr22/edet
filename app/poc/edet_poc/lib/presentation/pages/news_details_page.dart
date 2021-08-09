import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edet_poc/constants.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/cubit/news_details_cubit.dart';
import 'package:edet_poc/data/datasources/mck_remote_datasource.dart';
import 'package:edet_poc/data/repositories/news_repository.dart';

class NewsDetailsPage extends StatelessWidget {
  final _mckRemoteDataSource = MckRemoteDataSourceImpl();
  final int newsId;
  NewsDetailsPage({required this.newsId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      return const Center(
        child: CircularProgressIndicator(
          backgroundColor: blackBackgroundColor,
        ),
      );
    } else if (state is NewsDetailsStateLoaded) {
      return Text(state.newsItem.headline);
    } else if (state is NewsDetailsStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }
}

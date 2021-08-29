import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edet/cubit/news_cubit.dart';
import 'package:edet/data/datasources/mck_remote_datasource.dart';
import 'package:edet/data/repositories/news_repository.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/presentation/widgets/news/news_list_view.dart';
import 'package:edet/presentation/widgets/news/news_list_view_loading_indicator.dart';

class NewsList extends StatelessWidget {
  final mckRemoteDataSource = MckRemoteDataSourceImpl();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NewsCubit(NewsRepository(remoteDataSource: mckRemoteDataSource))
            ..getNews(),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          return stateManager(state);
        },
      ),
    );
  }

  Widget stateManager(NewsState state) {
    if (state is NewsStateInitial || state is NewsStateLoading) {
      return NewsListViewLoadingIndicator();
    } else if (state is NewsStateLoaded) {
      return NewsListView(news: state.news);
    } else if (state is NewsStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }
}

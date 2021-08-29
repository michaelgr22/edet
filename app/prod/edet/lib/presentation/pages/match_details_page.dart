import 'package:edet/constants.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/cubit/ticker_cubit.dart';
import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/global/global_app_bar.dart';
import 'package:edet/presentation/widgets/teams/match_details_page/match_details_page_loaded.dart';
import 'package:edet/presentation/widgets/teams/match_details_page/match_details_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDetailsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final MatchModel match;
  final List<PlayerModel> players;
  final tickerRemoteDataSource = TickerRemoteDataSourceImpl();

  MatchDetailsPage({
    Key? key,
    required this.match,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(submenuAppBarSize),
          child: GlobalAppBar(
            tabs: _tabs,
            showTabBar: false,
          ),
        ),
        body: BlocProvider(
          create: (_) => TickerCubit(
              TickerRepository(remoteDataSource: tickerRemoteDataSource))
            ..getTicker(match.id),
          child: BlocBuilder<TickerCubit, TickerState>(
            builder: (context, state) {
              return stateManager(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget stateManager(BuildContext context, TickerState state) {
    if (state is TickerStateInitial || state is TickerStateLoading) {
      return const MatchDetailsPageLoading();
    } else if (state is TickerStateLoaded) {
      return MatchDetailsPageLoaded(
        refreshTicker: _refreshTicker,
        match: match,
        players: players,
        ticker: state.tickerEntries,
        actions: state.tickerActions,
      );
    } else if (state is TickerStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }

  Future<void> _refreshTicker(BuildContext context) async {
    context.read<TickerCubit>().getTicker(match.id);
  }
}

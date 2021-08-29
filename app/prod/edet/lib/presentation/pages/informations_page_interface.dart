import 'package:edet/constants.dart';
import 'package:edet/cubit/ticker_cubit.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/global/global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class IInformationsPage {
  Widget buildBody(TickerState state);
}

class InformationsPage extends StatelessWidget {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();
  final TickerRepository tickerRepository;
  final LeagueModel league;
  final List<MatchModel> matches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;
  final ScrollController scrollController = ScrollController();

  InformationsPage({
    Key? key,
    required this.tickerRepository,
    required this.league,
    required this.matches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final MatchModel? liveMatch =
            MatchModel.findCurrentLiveTickerMatch(matches);
        if (liveMatch != null) {
          return TickerCubit(tickerRepository)..getTicker(liveMatch.id);
        } else {
          return TickerCubit(tickerRepository)..getTicker(null);
        }
      },
      child: BlocBuilder<TickerCubit, TickerState>(
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(submenuAppBarSize),
              child: GlobalAppBar(
                tabs: _tabs,
                showTabBar: false,
              ),
            ),
            body: buildBody(state),
          );
        },
      ),
    );
  }

  Future<void> refreshTicker(BuildContext context, MatchModel? match) async {
    if (match != null) {
      context.read<TickerCubit>().getTicker(match.id);
    } else {
      context.read<TickerCubit>().getTicker(null);
    }
  }

  void scrollToIndex(int index) {
    const double height = 100.0;
    scrollController.animateTo(index * height,
        duration: const Duration(milliseconds: 10), curve: Curves.linear);
  }

  Widget buildBody(TickerState state) {
    return const SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}

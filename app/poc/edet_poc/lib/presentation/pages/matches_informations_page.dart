import 'package:edet_poc/constants.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/cubit/ticker_cubit.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/data/repositories/ticker_repository.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MatchesInformationsPage extends StatefulWidget {
  final TickerRepository tickerRepository;
  final LeagueModel league;
  final List<MatchModel> teamMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  MatchesInformationsPage({
    Key? key,
    required this.tickerRepository,
    required this.teamMatches,
    required this.tickersOfMatches,
    required this.league,
    required this.players,
  }) : super(key: key);

  @override
  State<MatchesInformationsPage> createState() =>
      _MatchesInformationsPageState();
}

class _MatchesInformationsPageState extends State<MatchesInformationsPage> {
  final List<Tab> _tabs = appbarTaps.map((tab) => Tab(text: tab)).toList();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final MatchModel? liveMatch =
            MatchModel.findLiveMatch(widget.teamMatches);
        if (liveMatch != null) {
          return TickerCubit(widget.tickerRepository)..getTicker(liveMatch.id);
        } else {
          return TickerCubit(widget.tickerRepository)..getTicker(null);
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
            body: Container(
              color: greyBackgroundColor,
              child: stateManager(state),
            ),
          );
        },
      ),
    );
  }

  Widget buildBodyLoaded(List<TickerModel> tickersOfMatches) {
    return ListView(
      controller: _scrollController,
      children: [
        InformationsPageHeadline(
          headline: 'Spiele TSV',
          season: widget.league.leagueSeason,
        ),
        TeamMatchesContainer(
          refreshTicker: _refreshTicker,
          scrollMatchPageToTop: _scrollToTop,
          teamMatches: widget.teamMatches,
          tickersOfMatches: tickersOfMatches,
          players: widget.players,
        ),
      ],
    );
  }

  Widget buildbodyLoading() {
    return ListView(
      children: [
        InformationsPageHeadline(
          headline: 'Spiele TSV',
          season: widget.league.leagueSeason,
        ),
        const InformationsPageContainerBoilerplate(
          child: SizedBox(
            height: 1000.0,
          ),
        ),
      ],
    );
  }

  Widget stateManager(TickerState state) {
    if (state is TickerStateInitial || state is TickerStateLoading) {
      return buildbodyLoading();
    } else if (state is TickerStateLoaded) {
      return buildBodyLoaded(state.tickerEntries);
    } else if (state is TickerStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }

  Future<void> _refreshTicker(BuildContext context, MatchModel? match) async {
    if (match != null) {
      context.read<TickerCubit>().getTicker(match.id);
    } else {
      context.read<TickerCubit>().getTicker(null);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }
}

class TeamMatchesContainer extends StatelessWidget {
  final Future<void> Function(BuildContext context, MatchModel? match)
      refreshTicker;
  final Function() scrollMatchPageToTop;
  final List<MatchModel> teamMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  const TeamMatchesContainer({
    Key? key,
    required this.refreshTicker,
    required this.scrollMatchPageToTop,
    required this.teamMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: MatchesColumn(
        refreshTicker: refreshTicker,
        scrollMatchPageToTop: scrollMatchPageToTop,
        matches: teamMatches,
        tickersOfMatches: tickersOfMatches,
        players: players,
        numberOfRows: teamMatches.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
        isResultColor: true,
        showLeague: true,
      ),
    );
  }
}

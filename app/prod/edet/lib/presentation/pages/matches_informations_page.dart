import 'package:edet/constants.dart';
import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/cubit/ticker_cubit.dart';
import 'package:edet/data/models/league_model.dart';
import 'package:edet/data/models/match_model.dart';
import 'package:edet/data/models/player_model.dart';
import 'package:edet/data/models/ticker_model.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/pages/informations_page_interface.dart';
import 'package:edet/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet/presentation/widgets/teams/matches_column.dart';
import 'package:flutter/material.dart';

class MatchesInformationsPage extends InformationsPage
    implements IInformationsPage {
  MatchesInformationsPage({
    Key? key,
    required TickerRepository tickerRepository,
    required LeagueModel league,
    required List<MatchModel> matches,
    required List<TickerModel> tickersOfMatches,
    required List<PlayerModel> players,
  }) : super(
          key: key,
          tickerRepository: tickerRepository,
          league: league,
          matches: matches,
          tickersOfMatches: tickersOfMatches,
          players: players,
        );

  @override
  Widget buildBody(TickerState state) {
    return Container(
      color: greyBackgroundColor,
      child: stateManager(state),
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

  Widget buildBodyLoaded(List<TickerModel> tickersOfMatches) {
    return ListView(
      controller: scrollController,
      children: [
        InformationsPageHeadline(
          headline: 'Spiele TSV',
          season: league.leagueSeason,
        ),
        TeamMatchesContainer(
          refreshTicker: refreshTicker,
          scrollMatchPageToIndex: scrollToIndex,
          teamMatches: matches,
          tickersOfMatches: tickersOfMatches,
          players: players,
        ),
      ],
    );
  }

  Widget buildbodyLoading() {
    return ListView(
      controller: scrollController,
      children: [
        InformationsPageHeadline(
          headline: 'Spiele TSV',
          season: league.leagueSeason,
        ),
        const InformationsPageContainerBoilerplate(
          child: SizedBox(
            height: 10000.0,
          ),
        ),
      ],
    );
  }
}

class TeamMatchesContainer extends StatelessWidget {
  final Future<void> Function(BuildContext context, MatchModel? match)
      refreshTicker;
  final Function(int index)? scrollMatchPageToIndex;
  final List<MatchModel> teamMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  const TeamMatchesContainer({
    Key? key,
    required this.refreshTicker,
    required this.scrollMatchPageToIndex,
    required this.teamMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: MatchesColumn(
        refreshTicker: refreshTicker,
        scrollMatchPageToIndex: scrollMatchPageToIndex,
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

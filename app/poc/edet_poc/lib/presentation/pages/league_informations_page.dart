import 'package:edet_poc/constants.dart';
import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/cubit/ticker_cubit.dart';
import 'package:edet_poc/data/models/league_model.dart';
import 'package:edet_poc/data/models/match_model.dart';
import 'package:edet_poc/data/models/player_model.dart';
import 'package:edet_poc/data/models/standings_row_model.dart';
import 'package:edet_poc/data/models/ticker_model.dart';
import 'package:edet_poc/data/repositories/ticker_repository.dart';
import 'package:edet_poc/presentation/pages/informations_page_interface.dart';
import 'package:edet_poc/presentation/widgets/global/global_app_bar.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_container_boilerplate.dart';
import 'package:edet_poc/presentation/widgets/teams/informations_page/informations_page_headline.dart';
import 'package:edet_poc/presentation/widgets/teams/matches_column.dart';
import 'package:edet_poc/presentation/widgets/teams/standings_table.dart';
import 'package:flutter/material.dart';

class LeagueInformationsPage extends InformationsPage
    implements IInformationsPage {
  final List<StandingsRowModel> standings;

  LeagueInformationsPage({
    Key? key,
    required TickerRepository tickerRepository,
    required LeagueModel league,
    required this.standings,
    required List<MatchModel> leagueMatches,
    required List<TickerModel> tickersOfMatches,
    required List<PlayerModel> players,
  }) : super(
          key: key,
          tickerRepository: tickerRepository,
          league: league,
          matches: leagueMatches,
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
          headline: league.leagueShowname,
          season: league.leagueSeason,
        ),
        StandingsContainer(standings: standings),
        MatchesContainer(
          refreshTicker: refreshTicker,
          scrollMatchPageToTop: scrollToTop,
          leagueMatches: matches,
          tickersOfMatches: tickersOfMatches,
          players: players,
        )
      ],
    );
  }

  Widget buildbodyLoading() {
    return ListView(
      children: [
        InformationsPageHeadline(
          headline: league.leagueShowname,
          season: league.leagueSeason,
        ),
        const InformationsPageContainerBoilerplate(
          child: SizedBox(
            height: 1000.0,
          ),
        ),
      ],
    );
  }
}

class StandingsContainer extends StatelessWidget {
  final List<StandingsRowModel> standings;

  const StandingsContainer({
    Key? key,
    required this.standings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: StandingsTable(
        standings: standings,
        numberOfRows: standings.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
      ),
    );
  }
}

class MatchesContainer extends StatelessWidget {
  final Future<void> Function(BuildContext context, MatchModel? match)
      refreshTicker;
  final Function() scrollMatchPageToTop;
  final List<MatchModel> leagueMatches;
  final List<TickerModel> tickersOfMatches;
  final List<PlayerModel> players;

  const MatchesContainer({
    Key? key,
    required this.refreshTicker,
    required this.scrollMatchPageToTop,
    required this.leagueMatches,
    required this.tickersOfMatches,
    required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationsPageContainerBoilerplate(
      child: MatchesColumn(
        refreshTicker: refreshTicker,
        scrollMatchPageToTop: scrollMatchPageToTop,
        matches: leagueMatches,
        tickersOfMatches: tickersOfMatches,
        players: players,
        numberOfRows: leagueMatches.length,
        dividerHeight: 3.0,
        rowHeight: null,
        isPreview: false,
        isResultColor: false,
        showLeague: false,
      ),
    );
  }
}

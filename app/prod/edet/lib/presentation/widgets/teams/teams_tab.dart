import 'package:edet/core/errors/exceptions.dart';
import 'package:edet/cubit/teams_cubit.dart';
import 'package:edet/data/datasources/fupa_remote_datasource.dart';
import 'package:edet/data/datasources/ticker_remote_datasource.dart';
import 'package:edet/data/repositories/fupa_repository.dart';
import 'package:edet/data/repositories/ticker_repository.dart';
import 'package:edet/presentation/widgets/teams/teams_tab_loaded.dart';
import 'package:edet/presentation/widgets/teams/teams_tab_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamsTab extends StatelessWidget {
  final String teamname;
  final String teamclass;
  final String teamseason;

  TeamsTab({
    Key? key,
    required this.teamname,
    required this.teamclass,
    required this.teamseason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FupaRemoteDataSource fupaRemoteDataSource = FupaRemoteDataSourceImpl(
        teamname: teamname, teamclass: teamclass, teamseason: teamseason);
    final FupaRepository fupaRepository =
        FupaRepository(remoteDataSource: fupaRemoteDataSource);

    final TickerRemoteDataSource tickerRemoteDataSource =
        TickerRemoteDataSourceImpl();
    final TickerRepository tickerRepository =
        TickerRepository(remoteDataSource: tickerRemoteDataSource);

    return BlocProvider(
      create: (_) =>
          TeamsCubit(fupaRepository, tickerRepository)..getTeamInformations(),
      child: BlocBuilder<TeamsCubit, TeamsState>(
        builder: (context, state) {
          return stateManager(state, tickerRepository);
        },
      ),
    );
  }

  Widget stateManager(TeamsState state, TickerRepository tickerRepository) {
    if (state is TeamsStateInitial || state is TeamsStateLoading) {
      return const TeamsTabLoading();
    } else if (state is TeamsStateLoaded) {
      return TeamsTabLoaded(
        refreshTeamsInformations: _refreshTeamsInformations,
        tickerRepository: tickerRepository,
        league: state.league,
        teamMatches: state.teamMatches,
        leagueMatches: state.leagueMatches,
        tickersOfMatches: state.tickersToday,
        standings: state.standings,
        players: state.players,
      );
    } else if (state is TeamsStateError) {
      return Text(
        state.message,
        style: const TextStyle(color: Colors.black),
      );
    } else {
      throw UndefinedStateException();
    }
  }

  Future<void> _refreshTeamsInformations(BuildContext context) async {
    context.read<TeamsCubit>().getTeamInformations();
  }
}

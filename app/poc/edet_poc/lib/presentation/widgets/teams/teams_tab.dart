import 'package:edet_poc/core/errors/exceptions.dart';
import 'package:edet_poc/cubit/teams_cubit.dart';
import 'package:edet_poc/data/datasources/fupa_remote_datasource.dart';
import 'package:edet_poc/data/datasources/ticker_remote_datasource.dart';
import 'package:edet_poc/data/repositories/fupa_repository.dart';
import 'package:edet_poc/data/repositories/ticker_repository.dart';
import 'package:edet_poc/presentation/widgets/teams/teams_tab_loaded.dart';
import 'package:edet_poc/presentation/widgets/teams/teams_tab_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamsTab extends StatelessWidget {
  final String teamname;
  final String teamclass;
  final String teamseason;
  FupaRemoteDataSource fupaRemoteDataSource;
  TickerRemoteDataSource tickerRemoteDataSource = TickerRemoteDataSourceImpl();

  TeamsTab({
    Key? key,
    required this.teamname,
    required this.teamclass,
    required this.teamseason,
  })  : fupaRemoteDataSource = FupaRemoteDataSourceImpl(
            teamname: teamname, teamclass: teamclass, teamseason: teamseason),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamsCubit(
        FupaRepository(remoteDataSource: fupaRemoteDataSource),
        TickerRepository(remoteDataSource: tickerRemoteDataSource),
      )..getTeamInformations(),
      child: BlocBuilder<TeamsCubit, TeamsState>(
        builder: (context, state) {
          return stateManager(state);
        },
      ),
    );
  }

  Widget stateManager(TeamsState state) {
    if (state is TeamsStateInitial || state is TeamsStateLoading) {
      return const TeamsTabLoading();
    } else if (state is TeamsStateLoaded) {
      return TeamsTabLoaded(
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
}

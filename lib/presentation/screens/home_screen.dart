import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/movie_bloc/movie_bloc.dart';
import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';
import '../../repository/movie_repository.dart';

import 'movies_list_screen.dart';

class HomeScreen extends StatefulWidget {
  String title;

  HomeScreen({required this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieRepository _movieRepository = MovieRepository();
  final architectureNamesList = ["Bloc", "MVVM"];

  Future buildOnPressed(useBloc) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => useBloc
              ? BlocProvider(
                  create: (context) {
                    BlocProvider.of<MovieDetailBloc>(context)
                        .add(StopMovieDetailLoading());
                    return MovieBloc(repository: _movieRepository)
                      ..add(RemoveAllTappedMovies());
                  },
                  child: MoviesListScreen(useBloc),
                )
              : MoviesListScreen(useBloc)));

  Widget buildHomeScreen() => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(architectureNamesList.length, (index) {
              var useBloc = index == 0;
              return Platform.isIOS
                  ? CupertinoButton(
                      child: Text(architectureNamesList[index]),
                      onPressed: () => buildOnPressed(useBloc),
                    )
                  : FloatingActionButton(
                      onPressed: () => buildOnPressed(useBloc),
                      child: Text(architectureNamesList[index]),
                      heroTag: '${architectureNamesList[index]}btn',
                    );
            }).toList()),
      );

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: buildHomeScreen(),
            navigationBar: CupertinoNavigationBar(middle: Text(widget.title)),
          )
        : Scaffold(
            body: buildHomeScreen(),
            appBar: AppBar(title: Text(widget.title)),
          );
  }
}

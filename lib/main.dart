import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:gl_test/view_models/movies_view_model.dart';
import 'logic/movie_bloc/movie_bloc.dart';
import 'logic/movie_detail_bloc/movie_detail_bloc.dart';
import 'repository/movie_repository.dart';

import 'presentation/screens/movies_list_screen.dart';
import 'presentation/screens/movie_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MovieRepository _movieRepository = MovieRepository();
  static const appTitle = 'Bloc / MVVM Movie App';

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(dynamic _)> routes = {
      MoviesListScreen.routeName: (_) => BlocProvider(
            create: (context) {
              BlocProvider.of<MovieDetailBloc>(context)
                  .add(StopMovieDetailLoading());
              return MovieBloc(repository: _movieRepository)
                ..add(RemoveAllTappedMovies());
            },
            child: MoviesListScreen(),
          ),
      MovieDetailScreen.routeName: (_) => MovieDetailScreen(),
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesViewModel(),
        ),
      ],
      child: BlocProvider(
        create: (context) => MovieDetailBloc(repository: _movieRepository),
        child: Platform.isIOS
            ? CupertinoApp(
                theme: const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                localizationsDelegates: const [
                  DefaultMaterialLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  DefaultWidgetsLocalizations.delegate,
                ],
                home: HomeScreen(title: appTitle),
                routes: routes,
              )
            : MaterialApp(
                theme: ThemeData(
                    primarySwatch: Colors.blue, brightness: Brightness.dark),
                home: HomeScreen(title: appTitle),
                routes: routes,
              ),
      ),
    );
  }
}

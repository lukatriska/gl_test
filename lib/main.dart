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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesViewModel(),
        ),
      ],
      child: BlocProvider(
        create: (context) => MovieDetailBloc(repository: _movieRepository),
        child: MaterialApp(
          title: 'Flutter Bloc',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark
          ),
          home: HomeScreen(title: 'Bloc / MVVM Movie App'),
          routes: {
            MoviesListScreen.routeName: (_) => BlocProvider(
                  create: (context) => MovieBloc(repository: _movieRepository)
                    ..add(FetchMovies()),
                  child: MoviesListScreen(),
                ),
            MovieDetailScreen.routeName: (ctx) => MovieDetailScreen(),
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/bloc/movie_bloc.dart';
import 'repository/movie_repository.dart';

import 'presentation/screens/movies_list_screen.dart';
import 'presentation/screens/movie_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final MovieBloc _movieBloc = MovieBloc();
  final MovieRepository _movieRepository = MovieRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: MyHomePage(title: 'MyHomePage'),
      routes: {
        MoviesListScreen.routeName: (_) => BlocProvider(
              create: (context) =>
                  MovieBloc(repository: _movieRepository)..add(FetchMovies()),
              child: MoviesListScreen(),
            ),
        MovieDetailScreen.routeName: (ctx) => const MovieDetailScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MoviesListScreen.routeName);
              },
              child: const Text('Bloc'),
              heroTag: 'blocbtn',
            ),
            FloatingActionButton(
              onPressed: () {},
              child: const Text('MVVM'),
              heroTag: 'mvvmbtn',
            )
          ],
        ),
      ),
    );
  }
}

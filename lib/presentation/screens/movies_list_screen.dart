import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/movie_bloc.dart';

class MoviesListScreen extends StatefulWidget {
  static const routeName = '/movies-list';

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MovieBloc movieBloc;

  @override
  initState() {
    print("initsate");
    super.initState();
    movieBloc = BlocProvider.of<MovieBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Movies"),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieNotLoaded) {
            return const Center(child: const Text("Movies not loaded"));
          }
          if (state is MovieLoaded) {
            print("state is MovieLoaded");
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(state.movies[0].name),
              ),
              itemCount: state.movies.length,
            );
          }
          return const Center();
        },
      ),
    );
  }
}

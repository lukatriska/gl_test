import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/screens/movie_detail_screen.dart';

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
            return const Center(child: Text("Movies not loaded"));
          }
          if (state is MovieLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(MovieDetailScreen.routeName);
                  },
                  title: Text(state.movies[index].name),
                );
              },
              itemCount: state.movies.length,
            );
          }
          return const Center();
        },
      ),
    );
  }
}

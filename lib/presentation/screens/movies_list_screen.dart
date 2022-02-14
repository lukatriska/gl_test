import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/components/movie_detail_widget.dart';
import 'package:gl_test/presentation/screens/movie_detail_screen.dart';
import 'package:gl_test/view_models/movies_view_model.dart';

import '../../logic/movie_bloc/movie_bloc.dart';
import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MoviesListScreen extends StatefulWidget {
  static const routeName = '/movies-list';

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MovieDetailBloc movieDetailBloc;

  @override
  initState() {
    super.initState();
    movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Movies"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            BlocProvider.of<MovieBloc>(context).add(RemoveAllTappedMovies());
            movieDetailBloc.add(StopMovieDetailLoading());
          }
          return BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MovieNotLoaded) {
                return const Center(child: Text("Movies not loaded"));
              }
              if (state is MovieLoaded) {
                return Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: RefreshIndicator(
                        onRefresh: () async =>
                            BlocProvider.of<MovieBloc>(context)
                                .add(PulledToRefresh()),
                        child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              var currentMovie = state.movies[index];
                              return ListTile(
                                selectedTileColor: Colors.grey,
                                selectedColor: Colors.black,
                                onTap: () {
                                  movieDetailBloc.add(FetchMovieImage(
                                    currentMovie.name,
                                    currentMovie.imageUrl,
                                  ));
                                  moviesViewModel.selectedMovie = currentMovie;
                                  BlocProvider.of<MovieBloc>(context)
                                      .add(MovieWasTapped(currentMovie.name));
                                  if (orientation == Orientation.portrait) {
                                    Navigator.of(context)
                                        .pushNamed(MovieDetailScreen.routeName);
                                  }
                                },
                                selected: true
                                    ? (currentMovie.wasTapped &&
                                        orientation == Orientation.landscape)
                                    : false,
                                title: Text(currentMovie.name),
                              );
                            },
                            itemCount: state.movies.length),
                      ),
                    ),
                    if (orientation == Orientation.landscape)
                      const Flexible(
                        flex: 2,
                        child: MovieDetailWidget(),
                      ),
                  ],
                );
              }
              return const Center();
            },
          );
        },
      ),
    );
  }
}

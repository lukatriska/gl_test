import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/view_models/movies_view_model.dart';

import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailWidget extends StatelessWidget {
  final bool useBloc;

  const MovieDetailWidget(this.useBloc, {Key? key}) : super(key: key);

  Widget buildBlocMovieDetail() =>
      BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieImageInitial) {
            return const Center(child: Text("Pick a movie"));
          }
          if (state is MovieImageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieImageNotLoaded) {
            return const Center(child: Text("Movies not loaded"));
          }
          if (state is MovieImageLoaded) {
            return buildMovieDetailWidget(state.movie);
          } else {
            return const Center();
          }
        },
      );

  Widget buildMVVMMovieDetail(moviesViewModel) {
    if (moviesViewModel.movieWasSelected) {
      return buildMovieDetailWidget(moviesViewModel.selectedMovie);
    } else {
      return const Center(child: Text("Pick a movie"));
    }
  }

  Widget buildMovieDetailWidget(selectedMovie) => LayoutBuilder(
      builder: (context, constraints) => Center(
            child: Column(
              children: [
                CachedNetworkImage(
                    imageUrl: selectedMovie.imageUrl,
                    height: constraints.maxHeight - 37),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SizedBox(
                    height: 35,
                    child: Text(
                      selectedMovie.name,
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ));

  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    return useBloc
        ? buildBlocMovieDetail()
        : buildMVVMMovieDetail(moviesViewModel);
  }
}

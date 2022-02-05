import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailScreen extends StatelessWidget {
  static const routeName = '/movie-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Detail"),
      ),
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieImageInitial || state is MovieImageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MovieImageNotLoaded) {
            return const Center(child: Text("Movies not loaded"));
          }
          if (state is MovieImageLoaded) {
            return Center(
              child: state.img,
            );
          }
          return const Center();
        },
      ),
    );
  }
}

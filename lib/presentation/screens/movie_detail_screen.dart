import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailScreen extends StatelessWidget {
  static const routeName = '/movie-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
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
              child: Column(
                children: [
                  CachedNetworkImage(imageUrl: state.imageUrl),
                  Card(
                    margin: const EdgeInsets.all(19),
                    elevation: 0,
                    child: Text(state.movieName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}

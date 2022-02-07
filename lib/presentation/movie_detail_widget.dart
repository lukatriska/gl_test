import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailWidget extends StatelessWidget {
  const MovieDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
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
          return LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: state.imageUrl,
                      height: constraints.maxHeight - 25,
                    ),
                    SizedBox(
                      height: 25,
                      child: Text(
                        state.movieName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center();
        }
      },
    );
  }
}

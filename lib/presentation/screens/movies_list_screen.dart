import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/movie_detail_widget.dart';
import 'package:gl_test/presentation/screens/movie_detail_screen.dart';

import '../../logic/movie_bloc/movie_bloc.dart';
import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MoviesListScreen extends StatefulWidget {
  static const routeName = '/movies-list';

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MovieDetailBloc movieDetailBloc;
  int tappedTileIndex = -1;

  @override
  initState() {
    super.initState();
    movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Movies"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
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
                      child: ListView.builder(
                        itemBuilder: (ctx, index) => ListTile(
                          selectedTileColor: Colors.grey,
                          selectedColor: Colors.black,
                          onTap: () {
                            movieDetailBloc.add(FetchMovieImage(
                              state.movies[index].name,
                              state.movies[index].imageUrl,
                            ));
                            setState(() => tappedTileIndex = index);
                            if (orientation == Orientation.portrait) {
                              Navigator.of(context)
                                  .pushNamed(MovieDetailScreen.routeName);
                            }
                          },
                          selected: true ? tappedTileIndex == index : false,
                          title: Text(
                            state.movies[index].name,
                          ),
                        ),
                        itemCount: state.movies.length,
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

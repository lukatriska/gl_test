import 'dart:io';

import 'package:flutter/cupertino.dart';
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

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      BlocProvider.of<MovieBloc>(context).add(RemoveAllTappedMovies());
      movieDetailBloc.add(StopMovieDetailLoading());
    }

    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        movieDetailBloc.navigatorPoppedOrWidgetDeactivated) {
      BlocProvider.of<MovieBloc>(context).add(RemoveAllTappedMovies());
      movieDetailBloc.add(StopMovieDetailLoading());
    }

    Widget buildCupertinoFlexibleWidget(orientation, state) {
      return SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async =>
                  BlocProvider.of<MovieBloc>(context).add(PulledToRefresh()),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  List.generate(state.movies.length, (index) {
                var currentMovie = state.movies[index];
                return GestureDetector(
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
                  child: Container(
                    color: currentMovie.wasTapped &&
                            orientation == Orientation.landscape
                        ? Colors.deepOrangeAccent
                        : Colors.black,
                    padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                    child: Text(currentMovie.name,
                        style: const TextStyle(color: Colors.white)),
                  ),
                );
              }).toList()),
            ),
          ],
        ),
      );
    }

    Widget buildMaterialFlexibleWidget(orientation, state) {
      return RefreshIndicator(
        onRefresh: () async =>
            BlocProvider.of<MovieBloc>(context).add(PulledToRefresh()),
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
      );
    }

    Widget buildListScreenBody() {
      return OrientationBuilder(
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
                        child: Platform.isIOS
                            ? buildCupertinoFlexibleWidget(orientation, state)
                            : buildMaterialFlexibleWidget(orientation, state)),
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
      );
    }

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("List of Movies"),
            ),
            child: buildListScreenBody(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("List of Movies"),
            ),
            body: buildListScreenBody(),
          );
  }
}

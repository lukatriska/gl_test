import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/components/movie_detail_widget.dart';
import 'package:gl_test/presentation/screens/movie_detail_screen.dart';
import 'package:gl_test/view_models/movies_view_model.dart';

import '../../logic/movie_bloc/movie_bloc.dart';
import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';
import '../../models/movie.dart';

class MoviesListScreen extends StatefulWidget {
  final bool useBloc;

  const MoviesListScreen(this.useBloc, {Key? key}) : super(key: key);

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MovieDetailBloc movieDetailBloc;

  @override
  initState() {
    super.initState();
    if (widget.useBloc) {
      movieDetailBloc = BlocProvider.of<MovieDetailBloc>(context);
    }
  }

  @override
  void deactivate() {
    if (!widget.useBloc) context.watch<MoviesViewModel>().removeTappedMovie();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    if (widget.useBloc) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        BlocProvider.of<MovieBloc>(context).add(RemoveAllTappedMovies());
        movieDetailBloc.add(StopMovieDetailLoading());
      }

      if (MediaQuery.of(context).orientation == Orientation.landscape &&
          movieDetailBloc.navigatorPoppedOrWidgetDeactivated) {
        BlocProvider.of<MovieBloc>(context).add(RemoveAllTappedMovies());
        movieDetailBloc.add(StopMovieDetailLoading());
        movieDetailBloc.navigatorPoppedOrWidgetDeactivated = false;
      }
    }

    Widget buildSliverList(orientation, movies) => SliverList(
            delegate:
                SliverChildListDelegate(List.generate(movies.length, (index) {
          var currentMovie = movies[index];
          return GestureDetector(
            onTap: () {
              if (widget.useBloc) {
                movieDetailBloc.add(FetchMovieImage(currentMovie));
                BlocProvider.of<MovieBloc>(context)
                    .add(MovieWasTapped(currentMovie.name));
              } else {
                moviesViewModel.removeTappedMovie();
                moviesViewModel.selectedMovie = currentMovie;
                moviesViewModel.notifyListeners();
              }

              if (orientation == Orientation.portrait) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(widget.useBloc)));
              }
            },
            child: Container(
              color:
                  currentMovie.wasTapped && orientation == Orientation.landscape
                      ? Colors.deepOrangeAccent
                      : Colors.black,
              padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
              child: Text(currentMovie.name,
                  style: const TextStyle(color: Colors.white)),
            ),
          );
        }).toList()));

    Widget buildCupertinoFlexibleWidget(orientation, state) => SafeArea(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async => widget.useBloc
                    ? BlocProvider.of<MovieBloc>(context).add(PulledToRefresh())
                    : moviesViewModel.pulledToRefresh(),
              ),
              buildSliverList(orientation,
                  widget.useBloc ? state.movies : moviesViewModel.movies),
            ],
          ),
        );

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
                  if (widget.useBloc) {
                    movieDetailBloc.add(FetchMovieImage(currentMovie));
                    BlocProvider.of<MovieBloc>(context)
                        .add(MovieWasTapped(currentMovie.name));
                  } else {
                    moviesViewModel.removeTappedMovie();
                    moviesViewModel.selectedMovie = currentMovie;
                    moviesViewModel.notifyListeners();
                  }

                  if (orientation == Orientation.portrait) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(widget.useBloc)));
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

    Widget buildBlocListScreenBody() => OrientationBuilder(
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
                              : buildMaterialFlexibleWidget(
                                  orientation, state)),
                      if (orientation == Orientation.landscape)
                        Flexible(
                          flex: 2,
                          child: MovieDetailWidget(widget.useBloc),
                        ),
                    ],
                  );
                }
                return const Center();
              },
            );
          },
        );

    Widget buildMVVMListScreenBody() =>
        OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            moviesViewModel.removeTappedMovie();
          } else {
            if (moviesViewModel.justPoppedMovie.name != "") {
              moviesViewModel.selectedMovie = moviesViewModel.justPoppedMovie;
              moviesViewModel.justPoppedMovie =
                  const Movie(name: '', imageUrl: '');
            }
          }
          return moviesViewModel.loading
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    Flexible(
                        child: Platform.isIOS
                            ? buildCupertinoFlexibleWidget(
                                orientation, moviesViewModel.movies)
                            : buildMaterialFlexibleWidget(
                                orientation, moviesViewModel.movies)),
                    if (orientation == Orientation.landscape)
                      Flexible(
                        flex: 2,
                        child: MovieDetailWidget(widget.useBloc),
                      ),
                  ],
                );
        });

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("List of Movies"),
            ),
            child: widget.useBloc
                ? buildBlocListScreenBody()
                : buildMVVMListScreenBody(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("List of Movies"),
            ),
            body: widget.useBloc
                ? buildBlocListScreenBody()
                : buildMVVMListScreenBody(),
          );
  }
}

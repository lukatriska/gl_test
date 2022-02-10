import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../repository/movie_repository.dart';
import '../../models/movie.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  Orientation lastOrientation = Orientation.portrait;

  MovieBloc({required this.repository}) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async =>
        emit(MovieLoaded(await repository.fetchMovies(), event.orientation)));
    on<MovieWasTapped>((event, emit) async {
      // tappedMovieIndex = event.index;
      emit(MovieLoaded(await repository.fetchMovies(tappedName: event.name),
          event.orientation));
    });
    on<PulledToRefresh>((event, emit) async {
      print("event.orientation -- ${event.orientation}");
      emit(MovieLoaded(
        await repository.fetchMovies(shuffle: true), event.orientation));
    });
    on<SaveCurrentOrientation>((event, emit) async {
      lastOrientation = event.orientation;
      emit(MovieLoaded(await repository.fetchMovies(),
          event.orientation));
    });
    on<RemoveAllTappedMovies>((event, emit) async {
      emit(MovieLoaded(await repository.fetchMovies(untapMovie: true),
          event.orientation));
    });
  }
}

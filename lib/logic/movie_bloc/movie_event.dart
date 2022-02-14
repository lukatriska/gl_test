part of 'movie_bloc.dart';

class MovieEvent {}

class FetchMovies extends MovieEvent {}

class MovieWasTapped extends MovieEvent {
  final String name;

  MovieWasTapped(this.name);
}

class PulledToRefresh extends MovieEvent {
}

class RemoveAllTappedMovies extends MovieEvent {}
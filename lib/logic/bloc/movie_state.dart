part of 'movie_bloc.dart';

class MovieState {}

class MovieInitial extends MovieState {}

class MovieNotLoaded extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;

  MovieLoaded(this.movies);
}
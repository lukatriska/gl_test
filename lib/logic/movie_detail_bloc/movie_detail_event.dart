part of 'movie_detail_bloc.dart';

class MovieDetailEvent {}

class StopMovieDetailLoading extends MovieDetailEvent {}

class FetchMovieImage extends MovieDetailEvent {
  final Movie movie;

  FetchMovieImage(this.movie);
}

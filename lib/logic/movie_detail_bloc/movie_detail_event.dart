part of 'movie_detail_bloc.dart';

class MovieDetailEvent {}

class StopMovieDetailLoading extends MovieDetailEvent {}

class FetchMovieImage extends MovieDetailEvent {
  final String movieName;
  final String imageUrl;

  FetchMovieImage(this.movieName, this.imageUrl);
}

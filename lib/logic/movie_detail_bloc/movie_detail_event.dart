part of 'movie_detail_bloc.dart';

class MovieDetailEvent {}

class FetchMovieImage extends MovieDetailEvent {
  final String imageUrl;

  FetchMovieImage(this.imageUrl);
}

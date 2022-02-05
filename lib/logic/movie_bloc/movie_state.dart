part of 'movie_bloc.dart';

class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieNotLoaded extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;

  MovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

// class MovieImageLoaded extends MovieState {
//   final Image img;
//
//   MovieImageLoaded(this.img);
//
//   @override
//   List<Object> get props => [img];
// }

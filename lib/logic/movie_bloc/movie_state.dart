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
  final Orientation orientation;


  MovieLoaded(this.movies, this.orientation);

  @override
  List<Object> get props => [movies];
}


part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieImageInitial extends MovieDetailState {}

class MovieImageNotLoaded extends MovieDetailState {}

class MovieImageLoading extends MovieDetailState {}

class MovieImageLoaded extends MovieDetailState {
  final String movieName;
  final String imageUrl;

  MovieImageLoaded(this.movieName, this.imageUrl);

  @override
  List<Object> get props => [movieName, imageUrl];
}

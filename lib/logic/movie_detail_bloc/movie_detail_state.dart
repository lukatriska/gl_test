part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieImageInitial extends MovieDetailState {}

class MovieImageNotLoaded extends MovieDetailState {}

class MovieImageLoading extends MovieDetailState {}

class MovieImageLoaded extends MovieDetailState {
  final Image img;

  MovieImageLoaded(this.img);

  @override
  List<Object> get props => [img];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/movie_repository.dart';

part 'movie_detail_event.dart';

part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepository repository;

  MovieDetailBloc({required this.repository}) : super(MovieImageInitial()) {
    on<FetchMovieImage>((event, emit) =>
        emit(MovieImageLoaded(event.movieName, event.imageUrl)));
    on<StopMovieDetailLoading>((event, emit) => emit(MovieImageInitial()));
  }
}

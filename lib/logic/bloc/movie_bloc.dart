import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/movie_repository.dart';
import '../../models/movie.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc({required this.repository}) : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async =>
        emit(MovieLoaded(await repository.fetchMovies())));
  }

  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is FetchMovies) {
      yield* _mapMoviesToState();
    }
  }

  Stream<MovieState> _mapMoviesToState() async* {
    yield MovieLoading();
    var movies = await repository.fetchMovies();
    if (movies.isEmpty) {
      yield MovieNotLoaded();
    } else {
      yield MovieLoaded(movies);
    }
  }
}

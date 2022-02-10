part of 'movie_bloc.dart';

class MovieEvent {}

class FetchMovies extends MovieEvent {
  final Orientation orientation;

  FetchMovies({this.orientation = Orientation.portrait});
}

class MovieWasTapped extends MovieEvent {
  final String name;
  final Orientation orientation;

  MovieWasTapped(this.name, this.orientation);
}

class PulledToRefresh extends MovieEvent {
  final Orientation orientation;

  PulledToRefresh(this.orientation);
}

class SaveCurrentOrientation extends MovieEvent {
  final Orientation orientation;

  SaveCurrentOrientation(this.orientation);
}

class RemoveAllTappedMovies extends MovieEvent {
  final Orientation orientation;

  RemoveAllTappedMovies(this.orientation);

}
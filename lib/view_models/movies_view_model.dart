import 'package:flutter/material.dart';
import 'package:gl_test/models/movie.dart';

import '../models/movie_error.dart';
import '../repository/movie_services.dart';

class MoviesViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Movie> _movies = [];
  late MovieError _movieError;
  late Movie _selectedMovie;

  Movie get selectedMovie => _selectedMovie;

  bool get loading => _loading;

  List<Movie> get movies => _movies;

  MovieError get movieError => _movieError;

  set movieError(MovieError value) {
    _movieError = value;
  }

  set movies(List<Movie> value) {
    _movies = value;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set selectedMovie(Movie value) {
    _selectedMovie = value;
  }

  getMovies() async {
    _loading = true;
    var response = await MovieServices.getMovies();
    _movies = response;
    _loading = false;
  }
}

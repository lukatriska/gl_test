import 'package:flutter/material.dart';
import 'package:gl_test/models/movie.dart';

import '../repository/movie_services.dart';

class MoviesViewModel extends ChangeNotifier {
  bool _loading = false;
  bool movieWasSelected = false;
  Movie justPoppedMovie = const Movie(name: "", imageUrl: "");

  List<Movie> movies = [];
  late Movie _selectedMovie;

  Movie get selectedMovie => _selectedMovie;

  bool get loading => _loading;

  MoviesViewModel() {
    getMovies();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set selectedMovie(Movie movie) {
    _selectedMovie = movie;
    var movieTappedIndex =
        movies.indexWhere((element) => element.name == movie.name);
    movies[movieTappedIndex] = Movie(
        imageUrl: movies[movieTappedIndex].imageUrl,
        name: movies[movieTappedIndex].name,
        wasTapped: true);
    movieWasSelected = true;
  }

  removeTappedMovie() {
    for (var element in movies) {
      if (element.wasTapped) {
        var indexToRemoveWasTapped = movies.indexOf(element);
        movies[indexToRemoveWasTapped] = Movie(
            imageUrl: movies[indexToRemoveWasTapped].imageUrl,
            name: movies[indexToRemoveWasTapped].name,
            wasTapped: false);
      }
    }
    movieWasSelected = false;
  }

  getMovies() async {
    _loading = true;
    var response = await MovieServices.getMovies();
    movies = response;
    _loading = false;
  }

  pulledToRefresh() {
    movies.shuffle();
    notifyListeners();
  }
}

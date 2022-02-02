import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieRepository {
  Future<List<Movie>> fetchMovies() async {
    final response = rootBundle.loadString('assets/movies.json');
    final data = jsonDecode(await response);

    List<Movie> moviesList = [];
    data.forEach((k, v) => moviesList.add(Movie(k, v)));

    return moviesList;
  }
}
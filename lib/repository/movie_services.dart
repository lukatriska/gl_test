import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieServices {
  static Future<List<Movie>> getMovies() async {
    final response = rootBundle.loadString('assets/movies.json');
    final data = jsonDecode(await response);

    List<Movie> moviesList = [];
    data.forEach((k, v) => moviesList.add(Movie(name: k, imageUrl: v)));

    return moviesList;
  }
}

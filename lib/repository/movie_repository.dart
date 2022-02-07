import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieRepository {
  Future<List<Movie>> fetchMovies() async {
    final response = rootBundle.loadString('assets/movies.json');
    final data = jsonDecode(await response);

    List<Movie> moviesList = [];
    data.forEach((k, v) => moviesList.add(Movie(name: k, imageUrl: v)));

    return moviesList;
  }

  CachedNetworkImage fetchMovieImage(imageUrl) =>
      CachedNetworkImage(imageUrl: imageUrl);
}

import 'dart:convert';
import 'dart:async';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieRepository {
  List<Movie> savedList = [];

  List<Movie> makeAllMoviesUntapped(moviesList) {
    for (var element in moviesList) {
      if (element.wasTapped) {
        var indexToRemoveWasTapped = moviesList.indexOf(element);
        moviesList[indexToRemoveWasTapped] = Movie(
            imageUrl: moviesList[indexToRemoveWasTapped].imageUrl,
            name: moviesList[indexToRemoveWasTapped].name,
            wasTapped: false);
      }
    }
    return moviesList;
  }

  Future<List<Movie>> fetchMovies(
      {tappedName = -1, shuffle = false, untapMovie = false}) async {

    final response = rootBundle.loadString('assets/movies.json');
    final data = jsonDecode(await response);

    List<Movie> moviesList = [];
    if (savedList.isEmpty) {
      data.forEach((k, v) {
        moviesList.add(Movie(name: k, imageUrl: v));
      });
    } else {
      moviesList = [...savedList];
    }

    if (shuffle) {
      moviesList.shuffle();
    }

    if (tappedName != -1) {

      moviesList = makeAllMoviesUntapped(moviesList);

      var movieTappedIndex =
          moviesList.indexWhere((element) => element.name == tappedName);
      moviesList[movieTappedIndex] = Movie(
          imageUrl: moviesList[movieTappedIndex].imageUrl,
          name: moviesList[movieTappedIndex].name,
          wasTapped: true);
      savedList = [...moviesList];
    }
    if (shuffle) {
      savedList = [...moviesList];
    }
    if (savedList.isNotEmpty) {
      moviesList = [...savedList];
    }

    if (untapMovie) {
      moviesList = makeAllMoviesUntapped(moviesList);
    }

    return moviesList;
  }

  CachedNetworkImage fetchMovieImage(imageUrl) =>
      CachedNetworkImage(imageUrl: imageUrl);
}

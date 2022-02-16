import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';

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

  Future<List<Movie>> fetchMovies({
    tappedName = -1,
    shuffle = false,
    untapMovie = false,
  }) async {
    List<Movie> moviesList = [];
    if (savedList.isEmpty) {
      var response =
          await http.get(Uri.parse('https://putsreq.com/kSHrXHXsktsXj6rFK5LU'));
      final data = jsonDecode(response.body);
      data.forEach((name, imageUrl) =>
          moviesList.add(Movie(name: name, imageUrl: imageUrl)));
    } else {
      moviesList = [...savedList];
    }

    if (shuffle) {
      moviesList.shuffle();
      savedList = [...moviesList];
    }

    if (untapMovie) {
      moviesList = makeAllMoviesUntapped(moviesList);
      savedList = [...moviesList];
      return moviesList;
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
    if (savedList.isNotEmpty) {
      moviesList = [...savedList];
    }
    return moviesList;
  }

  CachedNetworkImage fetchMovieImage(imageUrl) =>
      CachedNetworkImage(imageUrl: imageUrl);
}

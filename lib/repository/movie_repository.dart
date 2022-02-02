import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieRepository {
  List<Movie> fetchMovies() {
    // final response = rootBundle.loadString('assets/movies.json');
    // var data = jsonDecode(await response);
    // print("loadMovies, $data");
    return [Movie("wewe", "wewe")];
  }
}
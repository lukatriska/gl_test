import 'dart:convert';
import 'package:http/http.dart' as http;


import '../models/movie.dart';

class MovieServices {
  static Future<List<Movie>> getMovies() async {
    final response =
    await http.get(Uri.parse('https://putsreq.com/kSHrXHXsktsXj6rFK5LU'));
    final data = jsonDecode(response.body);

    List<Movie> moviesList = [];
    data.forEach((k, v) => moviesList.add(Movie(name: k, imageUrl: v)));
    return moviesList;
  }
}

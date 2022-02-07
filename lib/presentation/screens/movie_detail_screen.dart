import 'package:flutter/material.dart';
import 'package:gl_test/presentation/movie_detail_widget.dart';


class MovieDetailScreen extends StatelessWidget {
  static const routeName = '/movie-detail';

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      Navigator.of(context).pop();
      return Container();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Details"),
        ),
        body: MovieDetailWidget(),
      );
    }
  }
}

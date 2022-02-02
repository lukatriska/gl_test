import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {

  static const routeName = '/movie-detail';

  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Detail"),
      ),
      // body: ,
    );
  }
}

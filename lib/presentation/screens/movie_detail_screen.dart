import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/components/movie_detail_widget.dart';

import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie-detail';

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          Navigator.of(context).pop();
        }
        return BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Movie Details"),
              ),
              body: const MovieDetailWidget(),
            );
          },
        );
      },
    );
    // }
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gl_test/presentation/components/movie_detail_widget.dart';

import '../../logic/movie_detail_bloc/movie_detail_bloc.dart';
import '../../view_models/movies_view_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final bool useBloc;

  const MovieDetailScreen(this.useBloc, {Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void deactivate() {
    BlocProvider.of<MovieDetailBloc>(context)
        .navigatorPoppedOrWidgetDeactivated = true;
    super.deactivate();
  }

  @override
  void initState() {
    BlocProvider.of<MovieDetailBloc>(context)
        .navigatorPoppedOrWidgetDeactivated = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          if (widget.useBloc) {
            BlocProvider.of<MovieDetailBloc>(context)
                .navigatorPoppedOrWidgetDeactivated = true;
          } else {
            moviesViewModel.justPoppedMovie = moviesViewModel.selectedMovie;
          }

          Navigator.of(context).pop();
        }

        return Platform.isIOS
            ? CupertinoPageScaffold(
                child: MovieDetailWidget(widget.useBloc),
                navigationBar:
                    const CupertinoNavigationBar(middle: Text("Movie Details")),
              )
            : Scaffold(
                body: MovieDetailWidget(widget.useBloc),
                appBar: AppBar(
                  title: const Text("Movie Details"),
                ),
              );
      },
    );
    // }
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_models/movies_view_model.dart';
import 'package:provider/provider.dart';

import 'movies_list_screen.dart';

class HomeScreen extends StatefulWidget {
  String title;

  HomeScreen({required this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget buildHomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: Platform.isIOS
            ? [
                CupertinoButton(
                  child: const Text('Bloc'),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(MoviesListScreen.routeName),
                ),
                CupertinoButton(
                  child: const Text('MVVM'),
                  onPressed: () {},
                ),
              ]
            : [
                FloatingActionButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(MoviesListScreen.routeName),
                  child: const Text('Bloc'),
                  heroTag: 'blocbtn',
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Text('MVVM'),
                  heroTag: 'mvvmbtn',
                )
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: buildHomeScreen(),
            navigationBar: CupertinoNavigationBar(
              middle: Text(widget.title),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: buildHomeScreen(),
          );
  }
}

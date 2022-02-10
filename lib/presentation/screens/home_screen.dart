import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    MoviesViewModel moviesViewModel = context.watch<MoviesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(MoviesListScreen.routeName),
              child: const Text('Bloc'),
              heroTag: 'blocbtn',
            ),
            FloatingActionButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                //
                // }));
              },
              child: const Text('MVVM'),
              heroTag: 'mvvmbtn',
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:movie_app/bloc/movies_bloc.dart';

import 'package:movie_app/src/pages/home_page.dart';
import 'package:movie_app/src/pages/actor_details_page.dart';
import 'package:movie_app/src/pages/movie_details_page.dart';
 
void main() {
  final moviesBloc = MoviesBloc();
  runApp(MyApp(moviesBloc: moviesBloc));
} 
 
class MyApp extends StatelessWidget {

  final MoviesBloc moviesBloc;

  MyApp({this.moviesBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: "/",
      routes: {
        '/'           : ( BuildContext context ) => HomePage(bloc: moviesBloc),
        'detail'      : ( BuildContext context ) => MovieDetails(),
        'actorDetail' : ( BuildContext context ) => ActorDetails(),
      },
    );
  }
}
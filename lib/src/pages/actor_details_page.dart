import 'package:flutter/material.dart';

import 'package:movie_app/singletons/movies_bloc.dart';

import 'package:movie_app/src/widgets/movie_horizontal_future.dart';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/models/movie_model.dart';

class ActorDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final Actor actor = ModalRoute.of(context).settings.arguments;
  
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon( Icons.arrow_back ), 
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.pinkAccent,
        // title: Text(actor.name),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          _actorDetails( context, actor ),
          SizedBox(height: 20.0,),
          _footer( context, moviesBloc, actor ),
        ],
      ),
    );
  }

  Widget _actorDetails( BuildContext context, Actor actor ) {
    return Column(
      children: <Widget>[
        Text(
          actor.name, 
          style: Theme.of(context).textTheme.headline,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          height: 320.0,
          width: double.infinity,
          // color: Colors.pinkAccent.withOpacity(0.1),
          child: Center(
            child: Hero(
              tag: actor.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/actor-placeholder.jpg'), 
                  image: NetworkImage( actor.getActorPhoto() ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actorDescription( ) {

  }

  Widget _footer(BuildContext context, MoviesBloc bloc, Actor actor) {
    
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Filmography', style: Theme.of(context).textTheme.subhead,),
          ),
          SizedBox(height: 15.0),
          FutureBuilder(
            future: bloc.getFilmography(actor),
            builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              return snapshot.hasData
              ? MovieHorizontalFuture(snapshot.data)
              : Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
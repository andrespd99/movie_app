import 'package:flutter/material.dart';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/providers/peliculas_provider.dart';
import 'package:movie_app/src/widgets/movie_horizontal.dart';

class ActorDetails extends StatelessWidget {
  
  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {

  
  final Actor actor = ModalRoute.of(context).settings.arguments;
  
  moviesProvider.getFilmography(actor);

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
          _footer( context ),
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
        Container(
          // child: Text(actor),
        )
      ],
    );
  }

  Widget _actorDescription( ) {

  }

  Widget _footer(BuildContext context) {
    
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
          StreamBuilder(
            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              return snapshot.hasData
              ? MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getFilmography,                  
                )
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
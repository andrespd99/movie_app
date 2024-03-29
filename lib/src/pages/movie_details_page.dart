import 'package:flutter/material.dart';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/peliculas_provider.dart';

class MovieDetails extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      

      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            _createAppBar( context, movie ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox( height: 20.0 ),
                  _posterTitle( context, movie ),
                  _descripcion( movie ),
                  SizedBox( height: 20.0 ),
                  _createCasting( movie ),
                  SizedBox( height: 50.0 ),
                ]
              ),
            )
          ],

        ),
      ),

    );
  }

  Widget _createAppBar( BuildContext context, Movie movie ) {

    final screenSize = MediaQuery.of(context).size;

    return SliverAppBar(

      elevation: 2.0,
      backgroundColor: Colors.pinkAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          width: screenSize.width * 0.6,
          child: Text(
            movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0,),
            textAlign: TextAlign.center,
          ),
        ),
          background: FadeInImage(
            image: NetworkImage(movie.getBackdropImg()),
            placeholder: AssetImage('assets/img/loading.gif'), 
            fit: BoxFit.cover,
          ),
        ),
      );
  }

  Widget _posterTitle( BuildContext context, Movie movie ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal:   20.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 0.1
                )
              ]
            ),
            child: Hero(
              tag: movie.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image(
                  image: NetworkImage( movie.getPosterImg() ),
                  height: 160.0,
                ),
              ),
            ),
          ),
          SizedBox(width: 15.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start  ,
              children: <Widget> [
                Text( movie.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis ),
                Text( movie.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.clip ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( movie.voteAverage.toString() ),
                  ],
                )
              ],  
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion( Movie movie ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text( 
        movie.overview, 
        textAlign: TextAlign.justify, 
      ),
    );

  }

  Widget _createCasting( Movie movie ) {
    
    final moviesProvider = new MoviesProvider();

    return FutureBuilder<List<Actor>>(
      future: moviesProvider.getCast( movie.id.toString() ),
      builder: (context, AsyncSnapshot<List<Actor>> snapshot) {
        
        if( snapshot.hasData ) {
          return _createActorsPageView( snapshot.data );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

  Widget _createActorsPageView( List<Actor> actors ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        pageSnapping: false,
        itemCount: actors.length,
        itemBuilder: (context, i) {

          return _actorCard( context, actors[i] );

        }
      ),
    );

  }

  Widget _actorCard( BuildContext context, Actor actor ) {

    return Container(
      margin: EdgeInsets.only(right: 10.0),
      // color: Colors.red,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/actor-placeholder.jpg'),
              image: NetworkImage( actor.getActorPhoto() ),
              fit: BoxFit.cover,
              height: 165.0,
            ),
          ),
          SizedBox( height: 5.0 ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: Text(
                actor.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,  
              ),
            ),
          )
        ],
      ),
    );

  }


}
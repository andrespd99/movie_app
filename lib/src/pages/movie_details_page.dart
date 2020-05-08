import 'package:flutter/material.dart';

import 'package:movie_app/singletons/movies_bloc.dart';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/widgets/rating.dart';

class MovieDetails extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final MovieDetailsArguments args  = ModalRoute.of(context).settings.arguments;

    final Movie movie = args.movie;
    final bool hasHero = args.hasHero;

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            _createAppBar( context, movie ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox( height: 20.0 ),
                  _posterTitle( context, movie, hasHero ),
                  _descripcion( movie ),
                  SizedBox( height: 20.0 ),
                  _createCasting( moviesBloc, movie ),
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

  Widget _posterTitle( BuildContext context, Movie movie, bool hasHero ) {

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
            child: hasHero 
                  ? Hero( tag: movie.uniqueId, child: _getPoster(movie) )
                  : _getPoster(movie)
            ),
          SizedBox(width: 15.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start  ,
              children: <Widget> [
                Text( 
                  '${movie.title} (${movie.releaseYear})', 
                  style: Theme.of(context).textTheme.title, 
                  overflow: TextOverflow.ellipsis, 
                ),
                Text( 
                  movie.originalTitle, 
                  style: Theme.of(context).textTheme.subhead, 
                  overflow: TextOverflow.clip 
                ),
                SizedBox(height: 5.0),
                Row(
                  children: rating( movie.voteAverage )
                  + [Text( movie.voteAverage.toString() )],
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

  Widget _createCasting( MoviesBloc bloc, Movie movie ) {

    return FutureBuilder<List<Actor>>(
      future: bloc.getCast( movie.id.toString() ),
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
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'actorDetail');
        },
        child: Column(
          children: <Widget>[
            Hero(
              tag: actor.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/actor-placeholder.jpg'),
                  image: NetworkImage( actor.getActorPhoto() ),
                  fit: BoxFit.cover,
                  height: 165.0,
                ),
              ),
            ),
            SizedBox( height: 5.0 ),
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    actor.name,
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,  
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'as ${actor.character}',
                    style: Theme.of(context).textTheme.caption
                                                      .copyWith( fontSize: 10.3 ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

  }

  Widget _getPoster( Movie movie ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.0),
      child: Image(
        image: NetworkImage( movie.getPosterImg() ),
        height: 160.0,
      ),
    );
  }


}

class MovieDetailsArguments {
  Movie movie;
  bool hasHero;

  MovieDetailsArguments(this.movie, {this.hasHero = true}); 

}
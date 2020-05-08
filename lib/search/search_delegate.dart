import 'package:flutter/material.dart';

import 'package:movie_app/singletons/movies_bloc.dart';

import 'package:movie_app/src/models/movie_model.dart';

import 'package:movie_app/src/pages/movie_details_page.dart';
import 'package:movie_app/src/pages/search_results_page.dart';


class DataSearch extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    /* Acciones de nuestro AppBar */
    return <Widget>[
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    /* Icono a la izquierda del AppBar */
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
        
      ),
      onPressed: () {
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    /* Crea los resultados que vamos a mostrar */
    if( query.isEmpty ) {
      return Center(
        child: Text('Type up something to look for'),
      );
    } else {      

      return _getSearchResults();
      // return _getMovieSearch();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    if( query.isEmpty ) {

      if( query.isEmpty ) {
        
        return _getEmptyQueryView(context);

      } else {

        return _getMovieSearch();

      }

    }
  }

  Widget _getEmptyQueryView(BuildContext context) {
    return ListView(
          children: <Widget> [
            SizedBox(height: 5.0),
            ListTile(
              title: Text(
                "Trending", 
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider( height: 3.0 )
          ] +
            moviesBloc.trendingMovies.map<ListTile>( (movie) {
              return ListTile(
                title: Text(
                  movie.title, 
                  style: TextStyle(color: Colors.pinkAccent),),
                onTap: () {
                  Navigator.pushNamed(
                    context, 'detail', 
                    arguments: MovieDetailsArguments( movie, hasHero: false ),
                  );
                },
              );
            }).toList(),
        );
  }

  FutureBuilder<List<Movie>> _getMovieSearch() {
    return FutureBuilder (
        future: moviesBloc.suggestMovies( query ),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

          if( snapshot.hasData ){
            
            final movies = snapshot.data;
            
            return ListView(
              children: movies.map( (movie) {

                movie.uniqueId = '${movie.id}-search';

                return ListTile(
                  leading: _leadingPoster( movie ),
                  title: Text( movie.title ),
                  subtitle: Text( movie.originalTitle ),
                  onTap: () {
                    // close( context, null );
                    movie.uniqueId = '${movie.id}-search';
                    Navigator.pushNamed(
                      context, 'detail', 
                      arguments: MovieDetailsArguments(movie),
                    );
                  },
                );
              }).toList() + [

                ListTile(
                  title: Text(
                    'Show more results',
                    style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(fontSize: 15.0, color: Colors.pinkAccent),
                    textAlign: TextAlign.center,
                    
                  ),
                  onTap: () {
                    this.showResults(context);
                  },
                ),
              ]
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },
        
      );
  }

  FutureBuilder<List<Movie>> _getSearchResults() {

    final searchPage = 1;

    return FutureBuilder(
      future: moviesBloc.getSearchResults( query, searchPage ),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if(snapshot.hasData){
          return SearchResults( 
            movies: snapshot.data, 
            nextPage: moviesBloc.getSearchResults,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }


      },

    );

  }

  Widget _leadingPoster( Movie movie ) {

    return Hero(
      tag: movie.uniqueId,
      child: FadeInImage(
        placeholder: AssetImage( 'assets/img/no-image.jpg' ), 
        image: NetworkImage( movie.getPosterImg() ),
        width: 50.0,
        fit: BoxFit.cover,
      ),
    );

  }

}
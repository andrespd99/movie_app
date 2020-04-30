import 'package:flutter/material.dart';
import 'package:movie_app/src/pages/movie_details_page.dart';
import 'package:movie_app/src/pages/search_results_page.dart';
import 'package:movie_app/src/providers/peliculas_provider.dart';

import 'package:movie_app/src/models/movie_model.dart';

class DataSearch extends SearchDelegate {
  
  final moviesProvider = new MoviesProvider();

  final popularMovies = new List<Movie>();

  final lastSearchMovies = List<Movie>();


  // final recentMovies = [];


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
    /* Son las sugerencias que aparecen cuando el usuario escribe */
    popularMovies.clear();
    /* Obtenemos las peliculas populares del momento */
    moviesProvider.getPopular().then( (p) => popularMovies.addAll(p.toList()) );

    if( query.isEmpty ) {
      return StreamBuilder(
        stream: moviesProvider.popularStream,
        builder: ( context, AsyncSnapshot<List<Movie>> snapshot ) {
          if(!snapshot.hasData) {
            return Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );        
          } 


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
              snapshot.data.map<ListTile>( (movie) {
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
      );
    } else {
      
      return _getMovieSearch();

    }

  }

  FutureBuilder<List<Movie>> _getMovieSearch() {
    return FutureBuilder (
        future: moviesProvider.searchMovie( query ),
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

  FutureBuilder<List<Movie>> _getSearchResults () {

    final searchPage = 1;

    return FutureBuilder(
      future: moviesProvider.getSearchResults( query, searchPage ),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

        if(snapshot.hasData){
          return SearchResults( 
            movies: snapshot.data, 
            nextPage: moviesProvider.getSearchResults,
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


  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   /* Son las sugerencias que aparecen cuando el usuario escribe */

  //   final listaSugerida = ( query.isEmpty ) 
  //                           ? peliculasRecientes 
  //                           : peliculas.where( 
  //                             (p) => p.toLowerCase().startsWith( query.toLowerCase() 
  //                           )).toList();
    

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: ( context, i ) {
        
  //       return ListTile(
  //         leading: Icon( Icons.movie ),
  //         title: Text( listaSugerida[i] ),
  //         onTap: () {
  //           seleccion = listaSugerida[i];
  //           showResults( context );
  //         },
  //       );

  //     }
  //   );
  // }

}
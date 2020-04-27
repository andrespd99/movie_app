import 'package:flutter/material.dart';
import 'package:movie_app/src/providers/peliculas_provider.dart';

import 'package:movie_app/src/models/movie_model.dart';

class DataSearch extends SearchDelegate {

  String seleccion = "";
  final peliculasProvider = new MoviesProvider();

  final cachedMovies = List<Movie>();

  final peliculasRecientes = [];


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
      return Container();
    } else {      

      return _getMovieSearch();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /* Son las sugerencias que aparecen cuando el usuario escribe */
    
    if( query.isEmpty ) {
      return Container();
    } else {
      
      return _getMovieSearch();

    }

  }

  FutureBuilder<List<Movie>> _getMovieSearch() {
    return FutureBuilder (
        future: peliculasProvider.searchMovie( query ),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

          if( snapshot.hasData ){
            
            final peliculas = snapshot.data;
            
            return ListView(
              children: peliculas.map( (pelicula) {

                pelicula.uniqueId = '${pelicula.id}-search';

                return ListTile(
                  leading: Hero(
                      tag: pelicula.uniqueId,
                      child: FadeInImage(
                      placeholder: AssetImage( 'assets/img/no-image.jpg' ), 
                      image: NetworkImage( pelicula.getPosterImg() ),
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text( pelicula.title ),
                  subtitle: Text( pelicula.originalTitle ),
                  onTap: () {
                    // close( context, null );
                    pelicula.uniqueId = '${pelicula.id}-search';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList()
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },
        
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
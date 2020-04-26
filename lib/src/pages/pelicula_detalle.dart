import 'package:flutter/material.dart';
import 'package:movie_app/src/models/pelicula_model.dart';

class PeliculaDetalle extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(

      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            _crearAppBar( pelicula ),
          ],

        ),
      ),

    );
  }

  Widget _crearAppBar( Pelicula pelicula ) {

    return SliverAppBar(

      elevation: 2.0,
      backgroundColor: Colors.pinkAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text( pelicula.title ),
      ),

    );

  }

}
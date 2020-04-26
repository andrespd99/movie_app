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
            _crearAppBar( context, pelicula ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 20.0),
                  _posterTitulo( context, pelicula ),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                ]
              ),
            )
          ],

        ),
      ),

    );
  }

  Widget _crearAppBar( BuildContext context, Pelicula pelicula ) {

    final screenSize = MediaQuery.of(context).size;

    return SliverAppBar(

      elevation: 2.0,
      backgroundColor: Colors.pinkAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0,),
          textAlign: TextAlign.center,
        ),
          background: FadeInImage(
            image: NetworkImage(pelicula.getBackdropImg()),
            placeholder: AssetImage('assets/img/loading.gif'), 
            fit: BoxFit.cover,
          ),
        ),
      );
  }

  Widget _posterTitulo( BuildContext context, Pelicula pelicula ) {

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.0),
              child: Image(
                image: NetworkImage( pelicula.getPosterImg() ),
                height: 160.0,
              ),
            ),
          ),
          SizedBox(width: 15.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start  ,
              children: <Widget> [
                Text( pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis ),
                Text( pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.clip ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( pelicula.voteAverage.toString() ),
                  ],
                )
              ],  
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion( Pelicula pelicula ) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text( 
        pelicula.overview, 
        textAlign: TextAlign.justify, 
      ),
    );

  }

}
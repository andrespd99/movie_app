import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({@required this.movies, @required this.nextPage});

  final _pageController = PageController(
    initialPage: 1, 
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener( () {
      if( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: movies.length,
        itemBuilder: ( context, i ) => _card(context, movies[i]),        
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    
    movie.uniqueId = '${movie.id}-horizontal';


    final card = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: movie.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(movie.getPosterImg()),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),
            SizedBox(height: 3.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 3.0),
                child: Text(
                  movie.title, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            )
          ],
        ),
      );
      
    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );

  }

//Tarjeta vieja.
//   List<Widget> _tarjetas(BuildContext context) {
//     return peliculas.map((pelicula) {
//       return Container(
//         margin: EdgeInsets.only(right: 15.0),
//         child: Column(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: FadeInImage(
//                   placeholder: AssetImage('assets/img/no-image.jpg'),
//                   image: NetworkImage(pelicula.getPosterImg()),
//                   fit: BoxFit.cover,
//                   height: 160.0),
//             ),
//             SizedBox(height: 3.0),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 padding: EdgeInsets.only(left: 3.0),
//                 child: Text(
//                   pelicula.title, 
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 2,
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }).toList();
//   }
}

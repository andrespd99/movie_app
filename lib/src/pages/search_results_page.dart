import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/pages/movie_details_page.dart';

class SearchResults extends StatelessWidget {

  final List<Movie> movies;
  final Function nextPage;  
  
  SearchResults({@required this.movies, @required this.nextPage, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createGridView(itemWidth, itemHeight),
    );
  }

  Widget _createGridView( double itemWidth, double itemHeight ) {
    return GridView.builder(
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 3,
      ), 
      itemBuilder: ( context, i ) {
        return _card( context, movies.elementAt(i) );
      } 

    );
  }

  Widget _card(BuildContext context, Movie movie) {
      
      movie.uniqueId = '${movie.id}-searchResult';

      final card = Container(
        height: 220.0,
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Hero(
                tag: movie.uniqueId,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                      )
                    ]
                  ),
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
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 3.0),
                  child: Text(
                    '${movie.title} (${movie.releaseDate.substring(0, 4)})', 
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
          Navigator.pushNamed(context, 'detail', arguments: MovieDetailsArguments(movie));
        },
      );

    }
}
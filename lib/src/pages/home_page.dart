import 'package:flutter/material.dart';
import 'package:movie_app/bloc/movies_bloc.dart';
import 'package:movie_app/search/search_delegate.dart';

import 'package:movie_app/src/widgets/card_swiper_widget.dart';
import 'package:movie_app/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  
  final MoviesBloc bloc;

  HomePage({this.bloc});

  @override
  Widget build(BuildContext context) {

    // moviesProvider.getPopular();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Cinex"),
          backgroundColor: Colors.pinkAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context, 
                  delegate: DataSearch()
                );
              },
            )
          ],
        ),
        body: Container(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperCards(),
              SizedBox(height: 25.0),
              _footer(context),  
            ],
          ),
        ));
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: bloc.getOnScreen(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(movies: snapshot.data);
        } else {
          return Container(
            height: MediaQuery.of(context).size.height * 0.53,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead,),
          ),
          SizedBox(height: 15.0),
          StreamBuilder(
            stream: bloc.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              return snapshot.hasData
              ? MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: bloc.getPopular,                  
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

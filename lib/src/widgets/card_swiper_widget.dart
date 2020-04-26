import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_app/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.53,
      padding: EdgeInsets.only(top: 15.0),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'), 
                image: NetworkImage( peliculas[index].getPosterImg()),
                fit: BoxFit.cover
              )            
            ),
          );
        },
        itemCount: peliculas.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}

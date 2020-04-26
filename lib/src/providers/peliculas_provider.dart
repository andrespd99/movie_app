import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:movie_app/src/models/actores_model.dart';
import 'package:movie_app/src/models/pelicula_model.dart';

class PeliculasProvider {

  String _apiKey = '33f176cad5a87619b85dc9788614f8f5';
  String _url = 'api.themoviedb.org';
  String _language = 'es';

  int _popularesPage = 0;
  bool _cargando = false;
  
  List<Pelicula> _populares = new List();
  
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;
  

  void disposeStreams() {
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    
    final resp = await http.get( url );
    final decodedData = json.decode( resp.body );

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, "3/movie/now_playing", {
      'api_key' : _apiKey,
      'language': _language
    });
    
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    if ( _cargando ) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url); 


    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;
    return resp;

  }

  Future<List<Actor>> getCast( String movieId ) async {
    
    /* Primero construimos el URL */
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
        'api_key'   : _apiKey,
        'language'  : _language,
    });


    /* Ahora guardamos la respuesta de la solicitud GET a dicho URL */
    final resp = await http.get(url);
    /* De esa respuesta, extraemos el body que es el Map del contenido del JSON  */
    /* decodedData es de tipo Map */
    final decodedData = json.decode( resp.body );
    /* Extraemos de ese Map el contenido del atributo cast y lo convertimos en un objeto de tipo
      Cast */
    final cast = new Cast.fromJsonList( decodedData['cast'] );
    /* Retornamos la lista de actores del objeto Cast */
    return cast.actores;

  }

}
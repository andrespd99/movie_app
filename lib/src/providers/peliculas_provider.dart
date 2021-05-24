import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/models/movie_model.dart';

class MoviesProvider {
  String _apiKey = '33f176cad5a87619b85dc9788614f8f5';
  String _url = 'api.themoviedb.org';
  String _language = 'es';

  int _popularPage = 0;
  // int _searchPage = 0;

  bool _loading = false;

  List<Movie> _popular = new List();
  List<Movie> _searchResults = new List();

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.movieList;
  }

  Future<List<Movie>> getOnScreen() async {
    final url = Uri.https(_url, "3/movie/now_playing",
        {'api_key': _apiKey, 'language': _language});

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];

    _loading = true;

    _popularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularPage.toString(),
    });

    final resp = await _processResponse(url);

    _popular.addAll(resp);
    popularSink(_popular);

    _loading = false;
    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    /* Primero construimos el URL */
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    /* Ahora guardamos la respuesta de la solicitud GET a dicho URL */
    final resp = await http.get(url);
    /* De esa respuesta, extraemos el body que es el Map del contenido del JSON  */
    /* decodedData es de tipo Map */
    final decodedData = json.decode(resp.body);
    /* Extraemos de ese Map el contenido del atributo cast y lo convertimos en un objeto de tipo
      Cast */
    final cast = new Cast.fromJsonList(decodedData['cast']);
    /* Retornamos la lista de actores del objeto Cast */
    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    return await _processResponse(url);
  }

  Future<List<Movie>> getSearchResults(String query, int searchPage) async {
    if (_loading) return [];

    _loading = true;

    // searchPage++;
    print('PAGINAAAAAAAAAAA $searchPage');

    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
      'page': searchPage.toString(),
    });

    print(url);

    final resp = await _processResponse(url);

    print(resp);

    _searchResults.addAll(resp);
    popularSink(_searchResults);

    _loading = false;

    return resp;
  }
}

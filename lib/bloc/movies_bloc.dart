import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:movie_app/src/models/cast_model.dart';
import 'package:movie_app/src/models/movie_model.dart';

class MoviesBloc {

  /* Our initial data for the REST API */
  String _apiKey = '33f176cad5a87619b85dc9788614f8f5';
  String _url = 'api.themoviedb.org';
  String _language = 'es';

  /* Some internal variables for Bloc's methods */
  bool _loading = false;
  int _popularPage = 0;
  List<Movie> _popularMovies = new List();
  List<Movie> _suggestedMovies = new List();
  List<Movie> _trendingMoviesList = new List();

  /* Getter of trending movies for search suggestion view when query is empty */
  List<Movie> get trendingMovies => _trendingMoviesList;

  /* Popular movies stream controller */
  final _popularStreamController = StreamController<List<Movie>>.broadcast();
  /* Getters: Sink and Stream for popular movies */
  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;
  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  /* Stream controller for suggestions */
  final _moviesSuggestionsStreamController = StreamController<List<Movie>>.broadcast();
  /* Getters: Sink and Stream for suggestions */
  Function(List<Movie>) get suggestionsSink => _moviesSuggestionsStreamController.sink.add;
  Stream<List<Movie>> get suggestionsStream => _moviesSuggestionsStreamController.stream;


  void dispose() {
    _popularStreamController?.close();
    _moviesSuggestionsStreamController?.close();
  }

  MoviesBloc() {
    this.getPopular();
    _trendingMoviesList.addAll(this._popularMovies);
  }

  Uri _getUrl(String getUrl, [Map<String, String> arguments]) {

    final Map<String, String> httpsArgs = {
      'api_key'   : _apiKey,
      'language'  : _language,
    }..addAll(arguments);

    if( getUrl.substring(0, 1) != '/' )
      getUrl = '/' + getUrl;

    final uri = Uri.https(_url, '3$getUrl', httpsArgs);

    return uri;

  }

  Future<List<Movie>> _processResponse(Uri url) async {
    
    final resp = await http.get( url );
    final decodedData = json.decode( resp.body );

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.movieList;
  }

  Future<List<Movie>> getOnScreen() async {

    final url = _getUrl('movie/now_playing');

    return await _processResponse(url);

  }

  Future<List<Movie>> getPopular() async {

    if ( _loading ) return [];
    
    _loading = true;
    _popularPage++;

    final url = _getUrl('/movie/popular', 
                        {'page' : _popularPage.toString()});

    final resp = await _processResponse(url); 

    _popularMovies.addAll(resp);
    popularSink( _popularMovies );

    _loading = false;
    return resp;

  }

  Future<List<Movie>> getSuggestedMovie( String query ) async {

    final url = _getUrl('/search/movie', 
                        {'query': query});

    final resp = await _processResponse(url);
    
    _suggestedMovies.addAll(resp);
    suggestionsSink( _suggestedMovies );

    return resp;
  
  }


  Future<List<Movie>> getFilmography( Actor actor ) async {

    List<Movie> filmography = new List();

    Uri url = _getUrl('discover/movie',
                        {'page'      : '1',
                        'with_cast' : '${actor.id}'});

    final resp = await http.get(url);
    final decodedData = json.decode( resp.body );
    
    int totalPages = decodedData['total_pages'];

    for( var page = 1; page <= totalPages; page++ ) {
      url = _getUrl('discover/movie',
                        {'page'      : '$page',
                        'with_cast' : '${actor.id}'});
      List<Movie> currentPageResp = await _processResponse(url);
      filmography.addAll(currentPageResp);
    }
    
    return await _processResponse(url);
    
  }


}


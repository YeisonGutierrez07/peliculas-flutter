import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/modelo_autores.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = 'fb52a9a522daca863fe406add795eea3';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int    _popularPage = 0;
  bool    _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink   => _popularesStreamController.sink.add;
  Stream<List<Pelicula>>   get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future <List<Pelicula>> _getServicesAPI(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future <List<Actor>> _getServicesAPIActors(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final actors = new Actores.fromListJson(decodeData['cast']);
    return actors.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language': _language
    });
    return _getServicesAPI(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    
    if (_cargando) return [];

    _popularPage ++;
    _cargando = true;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language,
      'page'    : _popularPage.toString()
    });

    final resp = await _getServicesAPI(url);
    
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;

    return resp;
  }

  Future <List<Actor>> getActorsByMovie(String peliID) async {
    final url = Uri.http(_url, '/3/movie/$peliID/credits', {
      'api_key' : _apiKey,
      'language': _language
    });
    return _getServicesAPIActors(url);
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {

    final url = Uri.https(_url, '/3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query
    });
    return _getServicesAPI(url);
  }
}
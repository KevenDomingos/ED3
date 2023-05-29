// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpotifyAPI {
  static const String _baseUrl = 'https://api.spotify.com/v1';
  static const String _clientId = 'f082dc102a564ebc9552de04f8016d47';
  static const String _clientSecret = '56edbb312be646378af1621612b9b4d5';

  static Future<String> _getAccessToken() async {
    final String basicAuth =
        base64Encode(utf8.encode('$_clientId:$_clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $basicAuth',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['access_token'];
    } else {
      throw Exception('Falha ao obter o token de acesso');
    }
  }

  static Future<Map<String, dynamic>> getArtist(String artistId) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/artists/$artistId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('Falha ao obter os dados do artista');
    }
  }

  static Future<List<dynamic>> getTopTracks(String artistId) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/artists/$artistId/top-tracks?market=US'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['tracks'];
    } else {
      throw Exception('Falha ao obter as músicas mais tocadas do artista');
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca de Cantores',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        hintColor: Colors.lightGreen,
        scaffoldBackgroundColor: const Color.fromRGBO(25, 20, 20, 1.0),
      ),
      home: const ArtistSearchPage(),
    );
  }
}

class ArtistSearchPage extends StatefulWidget {
  const ArtistSearchPage({Key? key}) : super(key: key);

  @override
  _ArtistSearchPageState createState() => _ArtistSearchPageState();
}

class _ArtistSearchPageState extends State<ArtistSearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String _nomeArtista = '';
  String _seguidores = '';
  List<String> _generos = [];
  String _imagemArtista = '';
  List<dynamic> _musicasMaisTocadas = [];

  void _buscarArtista() async {
    final artistName = _textEditingController.text;
    try {
      final artistId = await _getArtistId(artistName);
      final artistData = await SpotifyAPI.getArtist(artistId);
      final topTracks = await SpotifyAPI.getTopTracks(artistId);
      setState(() {
        _nomeArtista = artistData['name'];
        _seguidores = artistData['followers']['total'].toString();
        _generos = List<String>.from(artistData['genres']);
        _imagemArtista = artistData['images'][0]['url'];
        _musicasMaisTocadas = topTracks;
      });
    } catch (e) {
      setState(() {
        _nomeArtista = 'Erro';
        _seguidores = '';
        _generos = [];
        _imagemArtista = '';
        _musicasMaisTocadas = [];
      });
    }
  }

  Future<String> _getArtistId(String artistName) async {
    final accessToken = await SpotifyAPI._getAccessToken();
    final queryParameters = {'q': artistName, 'type': 'artist'};
    final uri = Uri.parse('${SpotifyAPI._baseUrl}/search')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final artists = responseData['artists']['items'];
      if (artists.isNotEmpty) {
        // Retornando o primeiro artista encontrado
        return artists[0]['id'];
      } else {
        throw Exception('Artista não encontrado');
      }
    } else {
      throw Exception('Falha ao obter o ID do artista');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca de Cantores',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Digite o nome do artista',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _buscarArtista,
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 16.0),
              if (_nomeArtista.isNotEmpty)
                Column(
                  children: [
                    if (_imagemArtista.isNotEmpty)
                      Image.network(
                        _imagemArtista,
                        width: 200,
                        height: 200,
                      ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Artista: $_nomeArtista',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    Text(
                      'Seguidores: $_seguidores',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    Text(
                      'Gêneros: ${_generos.join(", ")}',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Músicas mais tocadas:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    for (var track in _musicasMaisTocadas)
                      Text(
                        track['name'],
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.white),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

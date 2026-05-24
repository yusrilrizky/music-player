import 'package:dio/dio.dart';
import '../models/song_model.dart';

class MusicService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://api.spotify.com/v1';
  // Replace with your Spotify API key
  static const String spotifyApiKey = 'YOUR_SPOTIFY_API_KEY';

  MusicService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'type': 'track',
          'limit': 20,
          'access_token': spotifyApiKey,
        },
      );

      if (response.statusCode == 200) {
        List<Song> songs = [];
        var items = response.data['tracks']['items'] as List;
        for (var item in items) {
          songs.add(Song(
            id: item['id'] ?? '',
            title: item['name'] ?? 'Unknown',
            artist: item['artists'][0]['name'] ?? 'Unknown Artist',
            album: item['album']['name'] ?? 'Unknown Album',
            imageUrl: item['album']['images'][0]['url'] ?? '',
            audioUrl: item['preview_url'] ?? '',
            duration: item['duration_ms'] ?? 0,
            releaseYear: int.tryParse(
              item['album']['release_date'].split('-')[0],
            ),
          ));
        }
        return songs;
      }
      return [];
    } catch (e) {
      throw 'Failed to search songs: $e';
    }
  }

  Future<List<Song>> getPopularSongs() async {
    try {
      final response = await _dio.get(
        '/browse/new-releases',
        queryParameters: {
          'limit': 20,
          'access_token': spotifyApiKey,
        },
      );

      if (response.statusCode == 200) {
        List<Song> songs = [];
        var items = response.data['albums']['items'] as List;
        for (var item in items) {
          songs.add(Song(
            id: item['id'] ?? '',
            title: item['name'] ?? 'Unknown',
            artist: item['artists'][0]['name'] ?? 'Unknown Artist',
            album: item['name'] ?? 'Unknown Album',
            imageUrl: item['images'][0]['url'] ?? '',
            audioUrl: '',
            duration: 0,
            releaseYear: int.tryParse(
              item['release_date'].split('-')[0],
            ),
          ));
        }
        return songs;
      }
      return [];
    } catch (e) {
      throw 'Failed to get popular songs: $e';
    }
  }

  Future<String?> getLyrics(String artist, String title) async {
    try {
      // Using genius API for lyrics
      const String geniusBaseUrl = 'https://api.genius.com';
      const String geniusToken = 'YOUR_GENIUS_API_TOKEN';

      final response = await Dio().get(
        '$geniusBaseUrl/search',
        queryParameters: {
          'q': '$title $artist',
          'access_token': geniusToken,
        },
      );

      if (response.statusCode == 200) {
        var hits = response.data['response']['hits'] as List;
        if (hits.isNotEmpty) {
          return hits[0]['result']['url'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Song>> getRecommendedSongs(String seedArtist) async {
    try {
      final response = await _dio.get(
        '/recommendations',
        queryParameters: {
          'seed_artists': seedArtist,
          'limit': 20,
          'access_token': spotifyApiKey,
        },
      );

      if (response.statusCode == 200) {
        List<Song> songs = [];
        var tracks = response.data['tracks'] as List;
        for (var track in tracks) {
          songs.add(Song(
            id: track['id'] ?? '',
            title: track['name'] ?? 'Unknown',
            artist: track['artists'][0]['name'] ?? 'Unknown Artist',
            album: track['album']['name'] ?? 'Unknown Album',
            imageUrl: track['album']['images'][0]['url'] ?? '',
            audioUrl: track['preview_url'] ?? '',
            duration: track['duration_ms'] ?? 0,
          ));
        }
        return songs;
      }
      return [];
    } catch (e) {
      throw 'Failed to get recommendations: $e';
    }
  }
}

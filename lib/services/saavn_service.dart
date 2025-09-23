import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retune/models/models.dart';

class SaavnService {
  static const String _baseUrl = 'https://saavn.dev/api';

  Future<SearchResponse> search(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/search/songs?query=$encodedQuery&page=0&limit=10');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        return SearchResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<DetailedSongModel?> getSongById(
    String songId, {
    bool includeLyrics = false,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/songs/$songId${includeLyrics ? '?lyrics=true' : ''}',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final songResponse = SongDetailsResponse.fromJson(jsonData);
        return songResponse.song;
      } else {
        throw Exception('Failed to fetch song: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Song fetch failed: $e');
    }
  }
}

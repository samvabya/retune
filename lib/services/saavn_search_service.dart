import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retune/models/models.dart';

class SaavnSearchService {
  static const String _baseUrl = 'https://saavn.dev/api';

  Future<SearchResponse> search(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/search?query=$encodedQuery');
      
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
}


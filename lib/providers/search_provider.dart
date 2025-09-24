import 'package:flutter/foundation.dart';
import 'package:retune/models/models.dart';
import 'package:retune/services/saavn_service.dart';

enum SearchState { idle, loading, success, error }

class SearchProvider with ChangeNotifier {
  final SaavnService _searchService = SaavnService();

  SearchResponse? _searchResponse;
  SearchState _state = SearchState.idle;
  String _errorMessage = '';
  String _currentQuery = '';

  SearchResponse? get searchResponse => _searchResponse;
  SearchState get state => _state;
  String get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _clearResults();
      return;
    }

    _currentQuery = query;
    _state = SearchState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _searchResponse = await _searchService.search(query);
      _state = SearchState.success;
    } catch (e) {
      _state = SearchState.error;
      _errorMessage = e.toString();
      _searchResponse = null;
    }

    notifyListeners();
  }

  void _clearResults() {
    _searchResponse = null;
    _state = SearchState.idle;
    _errorMessage = '';
    _currentQuery = '';
    notifyListeners();
  }

  void clearSearch() {
    _clearResults();
  }
}

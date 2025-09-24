import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:retune/models/models.dart';
import 'package:retune/services/saavn_service.dart';
import '../models/song.dart';
import '../services/hive_service.dart';

class SongProvider with ChangeNotifier {
  List<Song> _songs = [];
  bool _isLoading = false;
  List<Song> _randomPicks = [];
  List<Song> _suggestions = [];
  int _tabIndex = 0;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  List<Song> get randomPicks => _songs.isEmpty ? [] : _randomPicks;
  List<Song> get suggestions => _suggestions;
  int get tabIndex => _tabIndex;

  SongProvider() {
    loadSongs();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    _songs = HiveService.getAllSongs();
    _songs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _randomPicks = List.generate(
      5,
      (_) => _songs[Random().nextInt(_songs.length)],
    ).toSet().toList();

    notifyListeners();
    if(_songs.isNotEmpty) {
     await getSuggestions(_songs[0].id);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getSuggestions(String id) async {
    try {
      _suggestions = await SaavnService()
          .getSongSuggestionsById(id)
          .then(
            (suggestions) => suggestions.map((e) => Song.create(e)).toList(),
          );
    } catch (e) {
      _suggestions = [];
    }
  }

  Future<void> addSong(DetailedSongModel item) async {
    final song = Song.create(item);
    await HiveService.addSong(song);
    _songs.insert(0, song);
    notifyListeners();
  }

  Future<void> deleteSong(String id) async {
    await HiveService.deleteSong(id);
    _songs.removeWhere((song) => song.id == id);
    notifyListeners();
  }

  List<Song> searchSongs(String query) {
    return HiveService.searchSongs(query);
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}

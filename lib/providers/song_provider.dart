import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
  List<ArtistInfo> _artists = [];
  int? _artistIndex;
  List<DetailedSongModel> _songsByArtist = [];

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  List<Song> get randomPicks => _songs.isEmpty ? [] : _randomPicks;
  List<Song> get suggestions => _suggestions;
  int get tabIndex => _tabIndex;
  List<ArtistInfo> get artists => _artists;
  int? get artistIndex => _artistIndex;
  List<DetailedSongModel> get songsByArtist => _songsByArtist;

  SongProvider() {
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      _isLoading = true;
      notifyListeners();

      _songs = HiveService.getAllSongs();
      _songs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _randomPicks = List.generate(
        5,
        (_) => _songs[Random().nextInt(_songs.length)],
      ).toSet().toList();

      notifyListeners();
      if (_songs.isNotEmpty) {
        await getSuggestions(_songs[0].id);
        await getArtists();
      }
      notifyListeners();

      if (_artists.isNotEmpty) {
        _artistIndex = 0;
        await getSongsByArtist(_artists[0].id);
      }

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
    }
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

  Future<void> getArtists() async {
    try {
      _artistIndex = null;
      _artists = await Future.wait(
        _songs[0].artists.split(', ').map((e) async {
          return await SaavnService().getArtists(e);
        }).toList(),
      );
    } catch (e) {
      _artists = [];
      debugPrint(e.toString());
    }
  }

  Future<void> getSongsByArtist(String artistid) async {
    try {
      _songsByArtist = await SaavnService().getSongsByArtist(artistid);
    } catch (e) {
      _songsByArtist = [];
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

  Future<void> setArtistIndex(int index) async {
    _artistIndex = index;
    notifyListeners();
    await getSongsByArtist(_artists[index].id);
    notifyListeners();
  }
}

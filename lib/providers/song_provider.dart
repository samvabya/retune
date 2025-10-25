import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:retune/data/data.dart';
import 'package:retune/models/models.dart';
import 'package:retune/services/saavn_service.dart';
import '../models/song.dart';
import '../services/hive_service.dart';

final songProvider = ChangeNotifierProvider<SongProvider>(
  (ref) => SongProvider(),
);

class SongProvider with ChangeNotifier {
  List<Song> _songs = [];
  bool _isLoading = false;
  List<Song> _randomPicks = [];
  List<Song> _suggestions = [];
  int _tabIndex = 0;
  List<ArtistInfo> _artists = featuredArtists;
  ArtistInfo? _selectedArtist;
  List<DetailedSongModel> _songsByArtist = [];

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  List<Song> get randomPicks => _songs.isEmpty ? [] : _randomPicks;
  List<Song> get suggestions => _suggestions;
  int get tabIndex => _tabIndex;
  List<ArtistInfo> get artists => _artists;
  ArtistInfo? get selectedArtist => _selectedArtist;
  List<DetailedSongModel> get songsByArtist => _songsByArtist;

  SongProvider() {
    load();
  }

  Future<void> load() async {
    await loadSongs();
    await loadArtists();
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
      }
      notifyListeners();

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<void> loadArtists() async {
    try {
      var artistids = HiveService.getAllArtists();
      artistids.sort((a, b) => a.compareTo(b));

      _artists = await Future.wait(
        artistids.map((e) async {
          return await SaavnService().getArtistByName(e);
        }).toList(),
      );

      notifyListeners();

      if (_artists.isEmpty) {
        _artists = featuredArtists;
      }

      if (_artists.isNotEmpty) {
        _selectedArtist = _artists[0];
        await getSongsByArtist(_artists[0].id);
      }

      notifyListeners();
    } on Exception catch (e) {
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

  Future<void> addArtists(List<String> artistInfos) async {
    artistInfos.forEach(
      (element) async => await HiveService.addArtist(element),
    );
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  Future<void> setArtistIndex(ArtistInfo artist) async {
    _selectedArtist = artist;
    notifyListeners();
    await getSongsByArtist(artist.id);
    notifyListeners();
  }
}

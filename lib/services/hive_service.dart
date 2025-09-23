
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retune/models/song.dart';

class HiveService {
  static const String _songsBox = 'songs_box';
  static Box<Song>? _songsBoxInstance;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(SongAdapter());
    
    // Open boxes
    _songsBoxInstance = await Hive.openBox<Song>(_songsBox);
  }

  // Add a new song
  static Future<void> addSong(Song song) async {
    await _songsBoxInstance?.put(song.id, song);
  }

  // Get all songs
  static List<Song> getAllSongs() {
    return _songsBoxInstance?.values.toList() ?? [];
  }

  // Get a specific song
  static Song? getSong(String id) {
    return _songsBoxInstance?.get(id);
  }

  // Update a song
  static Future<void> updateSong(Song song) async {
    await _songsBoxInstance?.put(song.id, song);
  }

  // Delete a song
  static Future<void> deleteSong(String id) async {
    await _songsBoxInstance?.delete(id);
  }

  // Delete all songs
  static Future<void> deleteAllSongs() async {
    await _songsBoxInstance?.clear();
  }

  // Search songs
  static List<Song> searchSongs(String query) {
    final allSongs = getAllSongs();
    if (query.isEmpty) return allSongs;
    
    return allSongs.where((song) {
      return song.name.toLowerCase().contains(query.toLowerCase()) ||
             song.artists.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Close Hive
  static Future<void> close() async {
    await _songsBoxInstance?.close();
  }
}

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retune/models/song.dart';

class HiveService {
  static const String _songsBox = 'songs_box';
  static const String _artistsBox = 'artists_box';
  static Box<Song>? _songsBoxInstance;
  static Box<String>? _artistsBoxInstance;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    // Register adapters
    Hive.registerAdapter(SongAdapter());
    
    // Open boxes
    _songsBoxInstance = await Hive.openBox<Song>(_songsBox);
    _artistsBoxInstance = await Hive.openBox<String>(_artistsBox);
  }

  // Add a new song
  static Future<void> addSong(Song song) async {
    await _songsBoxInstance?.put(song.id, song);
  }

  // Get all songs
  static List<Song> getAllSongs() {
    return _songsBoxInstance?.values.toList() ?? [];
  }

  // Add a new artist
  static Future<void> addArtist(String artist) async {
    await _artistsBoxInstance?.put(artist, artist);
  }

  // Get all artists
  static List<String> getAllArtists() {
    return _artistsBoxInstance?.values.toList() ?? [];
  }

  // Close Hive
  static Future<void> close() async {
    await _songsBoxInstance?.close();
    await _artistsBoxInstance?.close();
  }
}
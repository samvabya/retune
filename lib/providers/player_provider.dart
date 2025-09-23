import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/services/saavn_service.dart';

enum LocalPlayerState {
  stopped,
  playing,
  paused,
  loading,
  buffering,
  error,
  completed,
}

enum RepeatMode { none, one, all }

class PlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SaavnService _songService = SaavnService();

  DetailedSongModel? _currentSong;
  LocalPlayerState _state = LocalPlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;
  RepeatMode _repeatMode = RepeatMode.none;
  bool _shuffleMode = false;
  String _errorMessage = '';
  List<DetailedSongModel> _queue = [];
  int _currentIndex = 0;
  ColorScheme? _imageColorScheme;

  // Getters
  DetailedSongModel? get currentSong => _currentSong;
  LocalPlayerState get state => _state;
  Duration get duration => _duration;
  Duration get position => _position;
  double get volume => _volume;
  RepeatMode get repeatMode => _repeatMode;
  bool get shuffleMode => _shuffleMode;
  String get errorMessage => _errorMessage;
  List<DetailedSongModel> get queue => _queue;
  int get currentIndex => _currentIndex;
  ColorScheme? get imageColorScheme => _imageColorScheme;

  bool get isPlaying => _state == LocalPlayerState.playing;
  bool get isPaused => _state == LocalPlayerState.paused;
  bool get isLoading => _state == LocalPlayerState.loading;
  bool get hasNext => _currentIndex < _queue.length - 1;
  bool get hasPrevious => _currentIndex > 0;

  double get progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    return _position.inMilliseconds / _duration.inMilliseconds;
  }

  PlayerProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      _duration = duration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      _position = position;
      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      switch (state) {
        case PlayerState.playing:
          _state = LocalPlayerState.playing;
          break;
        case PlayerState.paused:
          _state = LocalPlayerState.paused;
          break;
        case PlayerState.stopped:
          _state = LocalPlayerState.stopped;
          break;
        case PlayerState.completed:
          _state = LocalPlayerState.completed;
          _handleSongCompleted();
          break;
        default:
          _state = LocalPlayerState.completed;
          break;
      }
      notifyListeners();
    });
  }

  Future<void> playSong(String songId) async {
    try {
      _state = LocalPlayerState.loading;
      _errorMessage = '';
      notifyListeners();

      final song = await _songService.getSongById(songId);
      if (song == null) {
        throw Exception('Song not found');
      }

      await playSongModel(song);
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> playSongModel(DetailedSongModel song) async {
    try {
      _currentSong = song;

      // Get the best quality download URL
      String? audioUrl = _getBestQualityUrl(song.downloadUrl);

      if (audioUrl == null || audioUrl.isEmpty) {
        throw Exception('No audio URL available');
      }

      await _audioPlayer.play(UrlSource(audioUrl));
      _state = LocalPlayerState.playing;
      notifyListeners();
      _imageColorScheme = await ColorScheme.fromImageProvider(
        provider: NetworkImage(song.imageUrl),
      );
      notifyListeners();

      // Save the song to the local database
      await SongProvider().addSong(song);
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String? _getBestQualityUrl(List<DownloadUrl> urls) {
    if (urls.isEmpty) return null;

    // Priority order: 320kbps -> 160kbps -> 96kbps -> any available
    const qualityOrder = ['320', '160', '96'];

    for (String quality in qualityOrder) {
      for (DownloadUrl url in urls) {
        if (url.quality.contains(quality) && url.url.isNotEmpty) {
          return url.url;
        }
      }
    }

    // Return first available URL if no preferred quality found
    return urls.first.url.isNotEmpty ? urls.first.url : null;
  }

  Future<void> play() async {
    try {
      if (_currentSong == null) return;

      if (_state == LocalPlayerState.completed) {
        _audioPlayer.seek(Duration.zero);
        playSong(_currentSong!.id);
      }

      await _audioPlayer.resume();
      _state = LocalPlayerState.playing;
      notifyListeners();
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _state = LocalPlayerState.paused;
      notifyListeners();
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _state = LocalPlayerState.stopped;
      _position = Duration.zero;
      notifyListeners();
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _position = position;
      notifyListeners();
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      _volume = volume.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      _state = LocalPlayerState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setRepeatMode(RepeatMode mode) {
    _repeatMode = mode;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.none:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.none;
        break;
    }
    notifyListeners();
  }

  void toggleShuffle() {
    _shuffleMode = !_shuffleMode;
    notifyListeners();
  }

  Future<void> next() async {
    if (!hasNext && _repeatMode != RepeatMode.all) return;

    int nextIndex = _currentIndex + 1;
    if (nextIndex >= _queue.length && _repeatMode == RepeatMode.all) {
      nextIndex = 0;
    }

    if (nextIndex < _queue.length) {
      _currentIndex = nextIndex;
      await playSongModel(_queue[_currentIndex]);
    }
  }

  Future<void> previous() async {
    if (!hasPrevious && _repeatMode != RepeatMode.all) return;

    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0 && _repeatMode == RepeatMode.all) {
      prevIndex = _queue.length - 1;
    }

    if (prevIndex >= 0) {
      _currentIndex = prevIndex;
      await playSongModel(_queue[_currentIndex]);
    }
  }

  void _handleSongCompleted() {
    switch (_repeatMode) {
      case RepeatMode.one:
        // Replay current song
        _audioPlayer.seek(Duration.zero);
        playSong(_currentSong!.id);
        break;
      case RepeatMode.all:
      case RepeatMode.none:
        if (hasNext || _repeatMode == RepeatMode.all) {
          next();
        } else {
          _state = LocalPlayerState.stopped;
          _position = Duration.zero;
        }
        break;
    }
    notifyListeners();
  }

  void setQueue(List<DetailedSongModel> songs, int startIndex) {
    _queue = List.from(songs);
    _currentIndex = startIndex.clamp(0, _queue.length - 1);
    notifyListeners();
  }

  Future<void> addToQueueId(String songId) async {
      final song = await _songService.getSongById(songId);
      if (song == null) {
        throw Exception('Song not found');
      }

      addToQueue(song);
  }

  void addToQueue(DetailedSongModel song) {
    _queue.add(song);
    notifyListeners();
  }

  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;

    _queue.removeAt(index);
    if (index < _currentIndex) {
      _currentIndex--;
    } else if (index == _currentIndex && _currentIndex >= _queue.length) {
      _currentIndex = _queue.length - 1;
    }
    notifyListeners();
  }

  void clearQueue() {
    _queue.clear();
    _currentIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

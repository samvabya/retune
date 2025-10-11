import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerHandler() {
    _init();
  }

  void _init() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          playbackState.add(
            playbackState.value.copyWith(
              playing: true,
              controls: [
                MediaControl.skipToPrevious,
                MediaControl.pause,
                MediaControl.skipToNext,
              ],
              processingState: AudioProcessingState.ready,
            ),
          );
          break;
        case PlayerState.paused:
          playbackState.add(
            playbackState.value.copyWith(
              playing: false,
              controls: [
                MediaControl.skipToPrevious,
                MediaControl.play,
                MediaControl.skipToNext,
              ],
              processingState: AudioProcessingState.ready,
            ),
          );
          break;
        case PlayerState.completed:
          playbackState.add(
            playbackState.value.copyWith(
              playing: false,
              processingState: AudioProcessingState.completed,
            ),
          );
          break;
        default:
          break;
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      mediaItem.add(mediaItem.value?.copyWith(duration: duration));
    });

    // Initialize playback state
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.play,
          MediaControl.skipToNext,
        ],
        processingState: AudioProcessingState.idle,
      ),
    );
  }

  Future<void> playFromUrl(String url, MediaItem mediaItemData) async {
    try {
      mediaItem.add(mediaItemData);

      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.loading,
        ),
      );

      await _audioPlayer.play(UrlSource(url));

      playbackState.add(
        playbackState.value.copyWith(
          playing: true,
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.pause,
            MediaControl.skipToNext,
          ],
          processingState: AudioProcessingState.ready,
        ),
      );
    } catch (e) {
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
        ),
      );
    }
  }

  @override
  Future<void> play() async {
    await _audioPlayer.resume();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    // This will be handled by PlayerProvider
    await super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    // This will be handled by PlayerProvider
    await super.skipToPrevious();
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _audioPlayer.dispose();
    }
    await super.customAction(name, extras);
  }
}

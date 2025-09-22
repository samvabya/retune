import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double _imageSize = 200;

    return Material(
      color: Theme.of(context).colorScheme.onPrimaryFixed,
      child: Consumer<PlayerProvider>(
        builder: (context, player, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Hero(
                                tag: player.currentSong!.id,
                                child: CachedNetworkImage(
                                  imageUrl: player.currentSong!.imageUrl,
                                  // width: _imageSize,
                                  // height: _imageSize,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: _imageSize,
                                    height: _imageSize,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.music_note),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        width: _imageSize,
                                        height: _imageSize,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.music_note),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.currentSong!.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    player.currentSong!.primaryArtistsText,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: player.toggleShuffle,
                              icon: Icon(
                                Icons.shuffle,
                                color: player.shuffleMode
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: player.toggleRepeat,
                              icon: Icon(
                                player.repeatMode == RepeatMode.one
                                    ? Icons.repeat_one
                                    : Icons.repeat,
                                color: player.repeatMode != RepeatMode.none
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              _formatDuration(player.position),
                              style: const TextStyle(fontSize: 10),
                            ),
                            Expanded(
                              child: Slider(
                                padding: EdgeInsets.all(16),
                                value: player.progress,
                                onChanged: (value) {
                                  final position = Duration(
                                    milliseconds:
                                        (value * player.duration.inMilliseconds)
                                            .round(),
                                  );
                                  player.seek(position);
                                },
                              ),
                            ),
                            Text(
                              _formatDuration(player.duration),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: player.hasPrevious
                                  ? player.previous
                                  : null,
                              icon: const Icon(Icons.skip_previous),
                            ),
                            _buildPlayPauseButton(player, context),
                            IconButton(
                              onPressed: player.hasNext ? player.next : null,
                              icon: const Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlayPauseButton(PlayerProvider player, BuildContext context) {
    double _btnSize = 70;
    if (player.isLoading) {
      return Container(
        width: _btnSize,
        height: _btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
          strokeWidth: 2,
        ),
      );
    }

    return IconButton(
      onPressed: player.isPlaying ? player.pause : player.play,
      icon: Container(
        width: _btnSize,
        height: _btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          player.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Theme.of(context).colorScheme.onPrimary,
          size: _btnSize / 2,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

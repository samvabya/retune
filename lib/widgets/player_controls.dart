import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/screens/player_screen.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final player = ref.watch(playerProvider);
        ColorScheme colorScheme =
            player.imageColorScheme ?? Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => PlayerScreen(),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(0),
              // boxShadow: [
              //   BoxShadow(
              //     color: colorScheme.primaryContainer,
              //     blurRadius: 8,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                // Song info
                if (player.currentSong != null) ...[
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      ClipOval(
                        // borderRadius: BorderRadius.circular(16),
                        child: Hero(
                          tag: player.currentSong!.id,
                          child: CachedNetworkImage(
                            imageUrl: player.currentSong!.imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(Icons.music_note),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(Icons.music_note),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.currentSong!.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              player.currentSong!.primaryArtistsText,
                              style: TextStyle(
                                color: colorScheme.onPrimary.withOpacity(0.8),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      _buildPlayPauseButton(player, context, colorScheme),
                    ],
                  ),
                ],
                const SizedBox(height: 5),
                SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(
                      disabledThumbRadius: 0,
                      enabledThumbRadius: 0,
                    ),
                    activeTrackColor: colorScheme.onPrimary,
                    inactiveTrackColor: colorScheme.onPrimary.withOpacity(0.5),
                    trackHeight: 3,
                    trackShape: RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    value: player.progress,
                    onChanged: (value) {
                      final position = Duration(
                        milliseconds: (value * player.duration.inMilliseconds)
                            .round(),
                      );
                      player.seek(position);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayPauseButton(
    PlayerProvider player,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    double _btnSize = 48;
    if (player.isLoading) {
      return Container(
        width: _btnSize,
        height: _btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary,
        ),
        child: CircularProgressIndicator(
          color: colorScheme.onPrimary,
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
          color: colorScheme.primary,
        ),
        child: Icon(
          player.isPlaying ? Icons.pause : Icons.play_arrow,
          color: colorScheme.onPrimary,
          size: _btnSize - 10,
        ),
      ),
    );
  }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return '$twoDigitMinutes:$twoDigitSeconds';
  // }
}

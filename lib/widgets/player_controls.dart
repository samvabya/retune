import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/screens/player_screen.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        return GestureDetector(
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => PlayerScreen(),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Song info
                if (player.currentSong != null) ...[
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
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
                              style: const TextStyle(
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
                      _buildPlayPauseButton(player, context),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayPauseButton(PlayerProvider player, BuildContext context) {
    if (player.isLoading) {
      return Container(
        width: 48,
        height: 48,
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          player.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
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

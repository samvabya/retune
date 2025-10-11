import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/player_provider.dart';

class Queue extends ConsumerWidget {
  final PlayerProvider player;
  const Queue({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    ColorScheme colorScheme =
        player.imageColorScheme ?? Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Queue',
                style: TextStyle(color: colorScheme.onPrimary, fontSize: 20),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildQueueItem(
                context,
                ref,
                player.queue[index],
                colorScheme,
                index == player.currentIndex,
                index,
              ),
              itemCount: player.queue.length,
            ),
            Row(
              children: [
                Expanded(child: Divider(color: colorScheme.onPrimary)),
                TextButton(
                  onPressed: () {
                    player.setQueue([
                      ...player.queue,
                      ...player.suggestions,
                    ], player.currentIndex);
                  },
                  child: Text(
                    'Add All',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildQueueItem(
                context,
                ref,
                player.suggestions[index],
                colorScheme,
                false,
                null,
              ),
              itemCount: player.suggestions.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueItem(
    BuildContext context,
    WidgetRef ref,
    DetailedSongModel song,
    ColorScheme colorScheme,
    bool nowPlaying,
    int? index,
  ) {
    return Container(
      color: nowPlaying ? colorScheme.tertiary : null,
      child: ListTile(
        dense: true,
        leading: ClipOval(
          child: CachedNetworkImage(
            imageUrl: song.imageUrl,
            // width: 56,
            // height: 56,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              // width: 56,
              // height: 56,
              color: Colors.grey[300],
              child: const Icon(Icons.music_note),
            ),
            errorWidget: (context, url, error) => Container(
              // width: 56,
              // height: 56,
              color: Colors.grey[300],
              child: const Icon(Icons.music_note),
            ),
          ),
        ),
        title: Text(
          song.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: colorScheme.onPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.primaryArtistsText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => index != null && !nowPlaying
              ? ref.read(playerProvider.notifier).removeFromQueue(index)
              : ref.read(playerProvider.notifier).addToQueue(song),
          icon: Icon(
            index == null
                ? Icons.add
                : nowPlaying
                ? Icons.more_horiz
                : Icons.close,
            color: colorScheme.onPrimary,
          ),
        ),
        onTap: () {
          ref.read(playerProvider.notifier).playSongModel(song);
          Navigator.pop(context);
        },
      ),
    );
  }
}

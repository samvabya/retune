import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/player_provider.dart';

class SongCard extends ConsumerWidget  {
  final DetailedSongModel song;

  const SongCard({ super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
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
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.primaryArtistsText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: IconButton.filledTonal(
        onPressed: () => _onAddToQueue(context, ref, song),
        icon: const Icon(Icons.queue_music),
      ),
      onTap: () => _onSongTap(context, ref, song),
    );
  }

  void _onSongTap(BuildContext context, WidgetRef ref, DetailedSongModel song) {
    // Play the song using the player provider
    ref.read(playerProvider.notifier).playSongModel(song);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${song.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAddToQueue(BuildContext context, WidgetRef ref, DetailedSongModel song) {
    // Play the song using the player provider
    ref.read(playerProvider.notifier).addToQueue(song);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Song added to queue'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

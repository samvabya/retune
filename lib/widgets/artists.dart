import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/util.dart';

class Artists extends StatelessWidget {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: Consumer<SongProvider>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.23),

                SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.artists.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async =>
                          await state.setArtistIndex(state.artists[index]),
                      child: _buildArtistCard(
                        state.artists[index],
                        state.selectedArtist != null &&
                            index ==
                                state.artists.indexOf(state.selectedArtist!),
                        context,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    state.songsByArtist.isEmpty
                        ? 'Tap an artist to get started'
                        : 'Songs by ${state.selectedArtist!.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.songsByArtist.length,
                  itemBuilder: (context, index) =>
                      _buildSongTile(context, state.songsByArtist[index]),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildArtistCard(
    ArtistInfo artist,
    bool isSelected,
    BuildContext context,
  ) => AnimatedContainer(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInCirc,
    width: isSelected ? 150 : 120,
    margin: EdgeInsets.only(left: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            height: isSelected ? 170 : 150,
            width: 150,
            imageUrl: artist.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          artist.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );

  Widget _buildSongTile(BuildContext context, DetailedSongModel song) {
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
      trailing: IconButton(
        onPressed: () => _onAddToQueue(context, song.id),
        icon: const Icon(Icons.queue_music),
      ),
      onTap: () => _onSongTap(context, song.id),
    );
  }

  void _onSongTap(BuildContext context, String songid) {
    // Play the song using the player provider
    context.read<PlayerProvider>().playSong(songid);
  }

  void _onAddToQueue(BuildContext context, String songid) {
    context.read<PlayerProvider>().addToQueueId(songid);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Song added to queue'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

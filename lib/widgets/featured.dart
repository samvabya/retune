import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retune/data/data.dart';
import 'package:retune/models/song.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/util.dart';

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: Consumer<SongProvider>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Featured',
                    style: GoogleFonts.imperialScript(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: text.withOpacity(0.5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 190,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (state.songs.isEmpty)
                        ...featuredSongs
                            .take(3)
                            .map(
                              (song) => _buildSongCard(
                                song,
                                featuredSongs.indexOf(song) == 0,
                                context,
                              ),
                            )
                      else
                        ...state.randomPicks.map(
                          (item) => _buildSongCard(
                            item,
                            state.randomPicks.indexOf(item) == 0,
                            context,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: state.songs.isEmpty
                      ? Text(
                          'Popular',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : DefaultTabController(
                          length: 2,
                          child: TabBar(
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.only(right: 20),
                            isScrollable: true,
                            dividerHeight: 0,
                            indicator: BoxDecoration(),
                            tabAlignment: TabAlignment.start,
                            labelColor: text,
                            unselectedLabelColor: text.withOpacity(0.5),
                            splashFactory: NoSplash.splashFactory,
                            onTap: (value) => state.setTabIndex(value),
                            tabs: [
                              Tab(
                                child: Text(
                                  'For You',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Recently Played',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                if (state.isLoading)
                  LinearProgressIndicator(
                    color: text,
                    backgroundColor: surface,
                    minHeight: 1,
                  ),
                if (state.songs.isEmpty)
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featuredSongs.length,
                    itemBuilder: (context, index) =>
                        _buildSongTile(context, featuredSongs[index]),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.tabIndex == 0
                        ? state.suggestions.length
                        : state.songs.length,
                    itemBuilder: (context, index) => _buildSongTile(
                      context,
                      state.tabIndex == 0
                          ? state.suggestions[index]
                          : state.songs[index],
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongCard(Song song, bool isFirst, BuildContext context) =>
      Container(
        width: isFirst ? 150 : 120,
        margin: EdgeInsets.only(right: 10, left: isFirst ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _onSongTap(context, song.id),
              onLongPressStart: (details) {
                final offset = details.globalPosition;
                showMenu(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy,
                    MediaQuery.of(context).size.width - offset.dx,
                    MediaQuery.of(context).size.height - offset.dy,
                  ),
                  items: [
                    PopupMenuItem(
                      onTap: () => _onSongTap(context, song.id),
                      value: 'play',
                      child: Text('Play Now'),
                    ),
                    PopupMenuItem(
                      onTap: () => _onAddToQueue(context, song.id),
                      value: 'add',
                      child: Text('Add to Queue'),
                    ),
                  ],
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  height: 150,
                  width: 150,
                  imageUrl: song.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              song.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );

  Widget _buildSongTile(BuildContext context, Song song) {
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
          Text(song.artists, maxLines: 1, overflow: TextOverflow.ellipsis),
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
    // Play the song using the player provider
    context.read<PlayerProvider>().addToQueueId(songid);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Song added to queue'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

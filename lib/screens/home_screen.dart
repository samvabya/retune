import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/data/data.dart';
import 'package:retune/models/song.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/screens/search_screen.dart';
import 'package:retune/screens/settings_screen.dart';
import 'package:retune/util.dart';
import 'package:retune/widgets/player_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  Color currentTabColor = surface;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  void onTabChanged(int value) {
    setState(() {
      currentTabColor = [surface, secondary][value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              showSnack('Refreshing feed', context);
              await Provider.of<SongProvider>(
                context,
                listen: false,
              ).loadSongs();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: Icon(Icons.more_horiz),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            dividerHeight: 0,
            indicator: BoxDecoration(),
            labelStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            splashFactory: NoSplash.splashFactory,
            tabAlignment: TabAlignment.start,
            physics: ClampingScrollPhysics(),
            onTap: onTabChanged,
            tabs: const [
              Tab(text: 'New Songs'),
              Tab(text: 'Playlists'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [Featured(), Playlists()],
      ),
      bottomSheet: Consumer<PlayerProvider>(
        builder: (context, player, child) {
          if (player.currentSong == null) return const SizedBox.shrink();
          return const PlayerControls();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          ),
          child: Hero(
            tag: 'search',
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.onSurface,
              ),
              child: Center(
                child: Text(
                  'Search songs, albums and artists',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      body: Consumer<SongProvider>(
        builder: (context, state, child) {
          if (state.songs.isEmpty) {
            return Wrap(
              children: [
                ...featuredSongs.map(
                  (song) => _buildSongCard(song, false, context),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.23),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) =>
                        _buildSongCard(state.songs[index], index == 0, context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'For You',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                ...featuredSongs.map((song) => _buildSongTile(context, song)),
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
        margin: EdgeInsets.only(right: 10, left: isFirst ? 10 : 0),
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

class Playlists extends StatelessWidget {
  const Playlists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: secondary);
  }
}

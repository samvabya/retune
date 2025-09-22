import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/search_provider.dart';
import 'package:retune/widgets/search_result_card.dart';
import 'package:retune/widgets/search_section.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        Provider.of<SearchProvider>(context, listen: false).clearSearch();
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Hero(
              tag: 'search',
              child: Material(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,

                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search songs, albums and artists',
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<SearchProvider>().clearSearch();
                                },
                              ),
                            )
                          : null,
                    ),
                    onChanged: (query) {
                      setState(() {});
                      if (query.trim().isEmpty) {
                        context.read<SearchProvider>().clearSearch();
                      } else {
                        context.read<SearchProvider>().search(query.trim());
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  switch (provider.state) {
                    case SearchState.idle:
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      );

                    case SearchState.loading:
                      return const Center(child: CircularProgressIndicator());

                    case SearchState.error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${provider.errorMessage}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                provider.search(provider.currentQuery);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );

                    case SearchState.success:
                      final response = provider.searchResponse!;
                      return ListView(
                        children: [
                          // Top Results
                          SearchSection(
                            title: 'Top Results',
                            children: response.topQuery.results.map((song) {
                              return SearchResultCard(
                                title: song.title,
                                subtitle: song.primaryArtists,
                                imageUrl: song.imageUrl,
                                type: 'Song',
                                onTap: () => _onSongTap(context, song),
                              );
                            }).toList(),
                          ),

                          // Songs
                          SearchSection(
                            title: 'Songs',
                            showViewAll: response.songs.results.length > 5,
                            onViewAllTap: () => _showAllResults(
                              context,
                              'Songs',
                              response.songs.results,
                            ),
                            children: response.songs.results.take(5).map((
                              song,
                            ) {
                              return SearchResultCard(
                                title: song.title,
                                subtitle: song.primaryArtists,
                                imageUrl: song.imageUrl,
                                type: 'Song',
                                onTap: () => _onSongTap(context, song),
                              );
                            }).toList(),
                          ),

                          // Albums
                          SearchSection(
                            title: 'Albums',
                            showViewAll: response.albums.results.length > 5,
                            onViewAllTap: () => _showAllResults(
                              context,
                              'Albums',
                              response.albums.results,
                            ),
                            children: response.albums.results.take(5).map((
                              album,
                            ) {
                              return SearchResultCard(
                                title: album.title,
                                subtitle: '${album.artist} • ${album.year}',
                                imageUrl: album.imageUrl,
                                type: 'Album',
                                onTap: () =>
                                    _onItemTap(context, album.title, 'Album'),
                              );
                            }).toList(),
                          ),

                          // Artists
                          SearchSection(
                            title: 'Artists',
                            showViewAll: response.artists.results.length > 5,
                            onViewAllTap: () => _showAllResults(
                              context,
                              'Artists',
                              response.artists.results,
                            ),
                            children: response.artists.results.take(5).map((
                              artist,
                            ) {
                              return SearchResultCard(
                                title: artist.title,
                                subtitle: artist.description,
                                imageUrl: artist.imageUrl,
                                type: 'Artist',
                                onTap: () =>
                                    _onItemTap(context, artist.title, 'Artist'),
                              );
                            }).toList(),
                          ),

                          // Playlists
                          SearchSection(
                            title: 'Playlists',
                            showViewAll: response.playlists.results.length > 5,
                            onViewAllTap: () => _showAllResults(
                              context,
                              'Playlists',
                              response.playlists.results,
                            ),
                            children: response.playlists.results.take(5).map((
                              playlist,
                            ) {
                              return SearchResultCard(
                                title: playlist.title,
                                subtitle: playlist.description,
                                imageUrl: playlist.imageUrl,
                                type: 'Playlist',
                                onTap: () => _onItemTap(
                                  context,
                                  playlist.title,
                                  'Playlist',
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),
                        ],
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSongTap(BuildContext context, SongModel song) {
    // Play the song using the player provider
    context.read<PlayerProvider>().playSong(song.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${song.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onItemTap(BuildContext context, String title, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on $type: $title'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAllResults<T>(BuildContext context, String title, List<T> results) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _AllResultsScreen<T>(title: title, results: results),
      ),
    );
  }
}

// Helper screen for showing all results
class _AllResultsScreen<T> extends StatelessWidget {
  final String title;
  final List<T> results;

  const _AllResultsScreen({required this.title, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];

          if (item is SongModel) {
            return SearchResultCard(
              title: item.title,
              subtitle: item.primaryArtists,
              imageUrl: item.imageUrl,
              type: 'Song',
              onTap: () => _onItemTap(context, item.title, 'Song'),
            );
          } else if (item is AlbumModel) {
            return SearchResultCard(
              title: item.title,
              subtitle: '${item.artist} • ${item.year}',
              imageUrl: item.imageUrl,
              type: 'Album',
              onTap: () => _onItemTap(context, item.title, 'Album'),
            );
          } else if (item is ArtistModel) {
            return SearchResultCard(
              title: item.title,
              subtitle: item.description,
              imageUrl: item.imageUrl,
              type: 'Artist',
              onTap: () => _onItemTap(context, item.title, 'Artist'),
            );
          } else if (item is PlaylistModel) {
            return SearchResultCard(
              title: item.title,
              subtitle: item.description,
              imageUrl: item.imageUrl,
              type: 'Playlist',
              onTap: () => _onItemTap(context, item.title, 'Playlist'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _onItemTap(BuildContext context, String title, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on $type: $title'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

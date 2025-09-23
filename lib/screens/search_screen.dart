import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/models/models.dart';
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,

                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search songs, albums and artists',
                      hintStyle: Theme.of(context).textTheme.titleSmall!
                          .copyWith(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
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
                              return SearchResultCard(song: song);
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
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];

          if (item is DetailedSongModel) {
            return SearchResultCard(song: item);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

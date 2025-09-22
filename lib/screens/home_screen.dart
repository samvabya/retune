import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/screens/search_screen.dart';
import 'package:retune/widgets/player_controls.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            flexibleSpace: FlexibleSpaceBar(
              title: Image.asset('assets/retune.png', height: 16),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.surface,
                        BlendMode.hue,
                      ),
                      child: Image.asset('assets/girl.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<PlayerProvider>(
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
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Center(
                child: Text(
                  'Search songs, albums and artists',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

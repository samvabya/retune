import 'package:flutter/material.dart';
import 'package:retune/screens/search_screen.dart';

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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
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

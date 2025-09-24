import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/screens/search_screen.dart';
import 'package:retune/screens/settings_screen.dart';
import 'package:retune/util.dart';
import 'package:retune/widgets/artists.dart';
import 'package:retune/widgets/featured.dart';
import 'package:retune/widgets/player_controls.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

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
            labelPadding: const EdgeInsets.only(right: 50, left: 20),
            onTap: onTabChanged,
            tabs: const [
              Tab(text: 'New Songs'),
              Tab(text: 'Artists'),
            ],
          ),
        ),
      ),
      body: SoftEdgeBlur(
        edges: [
          EdgeBlur(
            type: EdgeType.topEdge,
            size: MediaQuery.heightOf(context) * 0.2,
            sigma: 15,
            controlPoints: [
              ControlPoint(position: 0.9, type: ControlPointType.visible),
              ControlPoint(position: 1, type: ControlPointType.transparent),
            ],
          ),
          EdgeBlur(
            type: EdgeType.bottomEdge,
            size: 100,
            sigma: 15,
            controlPoints: [
              ControlPoint(position: 0.5, type: ControlPointType.visible),
              ControlPoint(position: 1, type: ControlPointType.transparent),
            ],
          ),
        ],
        child: TabBarView(
          controller: tabController,
          children: const [Featured(), Artists()],
        ),
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

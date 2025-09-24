import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retune/models/models.dart';
import 'package:retune/providers/player_provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = 200;

    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        ColorScheme colorScheme =
            player.imageColorScheme ?? Theme.of(context).colorScheme;

        player.isPlaying ? _controller.repeat() : _controller.stop();
        return Container(
          decoration: BoxDecoration(color: colorScheme.primary),
          child: PageView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.onSurface,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            // borderRadius: BorderRadius.circular(28),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Hero(
                                tag: player.currentSong!.id,
                                child: RotationTransition(
                                  turns: Tween(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(_controller),
                                  child: CachedNetworkImage(
                                    imageUrl: player.currentSong!.imageUrl,
                                    // width: _imageSize,
                                    // height: _imageSize,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: imageSize,
                                      height: imageSize,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.music_note),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          width: imageSize,
                                          height: imageSize,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.music_note),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                player.currentSong!.primaryArtistsText,
                                style: TextStyle(
                                  color: colorScheme.onPrimary.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                player.currentSong!.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              IconButton(
                                onPressed: player.hasPrevious
                                    ? player.previous
                                    : null,
                                icon: Icon(
                                  Icons.fast_rewind,
                                  size: 30,
                                  color: player.hasPrevious
                                      ? colorScheme.onPrimary
                                      : colorScheme.onPrimary.withOpacity(0.5),
                                ),
                              ),
                              _buildPlayPauseButton(
                                player,
                                context,
                                colorScheme,
                              ),
                              IconButton(
                                onPressed: player.hasNext ? player.next : null,
                                icon: Icon(
                                  Icons.fast_forward,
                                  size: 30,
                                  color: player.hasNext
                                      ? colorScheme.onPrimary
                                      : colorScheme.onPrimary.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    thumbShape: RoundSliderThumbShape(
                                      disabledThumbRadius: 0,
                                      enabledThumbRadius: 0,
                                    ),
                                    activeTrackColor: colorScheme.onPrimary,
                                    inactiveTrackColor: colorScheme.onPrimary
                                        .withOpacity(0.5),
                                  ),
                                  child: Slider(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 10,
                                    ),
                                    value: player.progress,
                                    onChanged: (value) {
                                      final position = Duration(
                                        milliseconds:
                                            (value *
                                                    player
                                                        .duration
                                                        .inMilliseconds)
                                                .round(),
                                      );
                                      player.seek(position);
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _formatDuration(player.position),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: colorScheme.onPrimary
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      _formatDuration(player.duration),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: colorScheme.onPrimary
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(height: 15),
                          Row(
                            children: [
                              IconButton(
                                onPressed: player.toggleRepeat,
                                icon: Icon(
                                  player.repeatMode == RepeatMode.one
                                      ? Icons.repeat_one
                                      : Icons.repeat,
                                  color: player.repeatMode != RepeatMode.none
                                      ? colorScheme.onPrimary
                                      : colorScheme.onPrimary.withOpacity(0.5),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: player.toggleShuffle,
                                icon: Icon(
                                  Icons.shuffle,
                                  color: player.shuffleMode
                                      ? colorScheme.onPrimary
                                      : colorScheme.onPrimary.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Queue',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => _buildQueueItem(
                          context,
                          player.queue[index],
                          colorScheme.onPrimary,
                        ),
                        itemCount: player.queue.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQueueItem(
    BuildContext context,
    DetailedSongModel song,
    Color textColor,
  ) {
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
        style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            song.allArtistsText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.drag_handle, color: textColor),
      ),
      onTap: () => _onSongTap(context, song),
    );
  }

  void _onSongTap(BuildContext context, DetailedSongModel song) {
    // Play the song using the player provider
    context.read<PlayerProvider>().playSongModel(song);
    context.read<PlayerProvider>().clearQueue();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${song.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPlayPauseButton(
    PlayerProvider player,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    double btnSize = 70;
    if (player.isLoading) {
      return Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary,
        ),
        child: CircularProgressIndicator(
          color: colorScheme.onPrimary,
          strokeWidth: 2,
        ),
      );
    }

    return IconButton(
      onPressed: player.isPlaying ? player.pause : player.play,
      icon: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary,
        ),
        child: Icon(
          player.isPlaying ? Icons.pause : Icons.play_arrow,
          color: colorScheme.onPrimary,
          size: btnSize - 10,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

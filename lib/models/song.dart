import 'package:hive/hive.dart';
import 'package:retune/models/models.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song {
  @HiveField(0)
   String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String artists;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  final DateTime createdAt;


  Song({
    required this.id,
    required this.name,
    required this.artists,
    required this.imageUrl,
    required this.createdAt
  });

  Song.create(DetailedSongModel song) : 
       id = song.id,
       name = song.name,
       artists = song.allArtistsText,
       imageUrl = song.imageUrl,
       createdAt = DateTime.now();

}

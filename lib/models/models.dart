// models/image_model.dart
class ImageModel {
  final String quality;
  final String url;

  ImageModel({
    required this.quality,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      quality: json['quality'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quality': quality,
      'url': url,
    };
  }
}

// models/song_model.dart
class SongModel {
  final String id;
  final String title;
  final List<ImageModel> image;
  final String album;
  final String url;
  final String type;
  final String description;
  final String primaryArtists;
  final String singers;
  final String language;

  SongModel({
    required this.id,
    required this.title,
    required this.image,
    required this.album,
    required this.url,
    required this.type,
    required this.description,
    required this.primaryArtists,
    required this.singers,
    required this.language,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      album: json['album'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      primaryArtists: json['primaryArtists'] ?? '',
      singers: json['singers'] ?? '',
      language: json['language'] ?? '',
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
}

// models/album_model.dart
class AlbumModel {
  final String id;
  final String title;
  final List<ImageModel> image;
  final String artist;
  final String url;
  final String type;
  final String description;
  final String year;
  final String language;
  final String songIds;

  AlbumModel({
    required this.id,
    required this.title,
    required this.image,
    required this.artist,
    required this.url,
    required this.type,
    required this.description,
    required this.year,
    required this.language,
    required this.songIds,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      artist: json['artist'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? '',
      language: json['language'] ?? '',
      songIds: json['songIds'] ?? '',
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
}

// models/artist_model.dart
class ArtistModel {
  final String id;
  final String title;
  final List<ImageModel> image;
  final String type;
  final String description;
  final int position;

  ArtistModel({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.description,
    required this.position,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      position: json['position'] ?? 0,
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
}

// models/playlist_model.dart
class PlaylistModel {
  final String id;
  final String title;
  final List<ImageModel> image;
  final String url;
  final String language;
  final String type;
  final String description;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.language,
    required this.type,
    required this.description,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      url: json['url'] ?? '',
      language: json['language'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
}

// models/search_result_section.dart
class SearchResultSection<T> {
  final List<T> results;
  final int position;

  SearchResultSection({
    required this.results,
    required this.position,
  });
}

// models/search_response.dart
class SearchResponse {
  final bool success;
  final SearchResultSection<AlbumModel> albums;
  final SearchResultSection<SongModel> songs;
  final SearchResultSection<ArtistModel> artists;
  final SearchResultSection<PlaylistModel> playlists;
  final SearchResultSection<SongModel> topQuery;

  SearchResponse({
    required this.success,
    required this.albums,
    required this.songs,
    required this.artists,
    required this.playlists,
    required this.topQuery,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return SearchResponse(
      success: json['success'] ?? false,
      albums: SearchResultSection<AlbumModel>(
        results: (data['albums']['results'] as List<dynamic>?)
                ?.map((e) => AlbumModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        position: data['albums']['position'] ?? 0,
      ),
      songs: SearchResultSection<SongModel>(
        results: (data['songs']['results'] as List<dynamic>?)
                ?.map((e) => SongModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        position: data['songs']['position'] ?? 0,
      ),
      artists: SearchResultSection<ArtistModel>(
        results: (data['artists']['results'] as List<dynamic>?)
                ?.map((e) => ArtistModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        position: data['artists']['position'] ?? 0,
      ),
      playlists: SearchResultSection<PlaylistModel>(
        results: (data['playlists']['results'] as List<dynamic>?)
                ?.map((e) => PlaylistModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        position: data['playlists']['position'] ?? 0,
      ),
      topQuery: SearchResultSection<SongModel>(
        results: (data['topQuery']['results'] as List<dynamic>?)
                ?.map((e) => SongModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        position: data['topQuery']['position'] ?? 0,
      ),
    );
  }
}

class DetailedAlbumInfo {
  final String? id;
  final String? name;
  final String? url;

  DetailedAlbumInfo({
    this.id,
    this.name,
    this.url,
  });

  factory DetailedAlbumInfo.fromJson(Map<String, dynamic> json) {
    return DetailedAlbumInfo(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class ArtistInfo {
  final String id;
  final String name;
  final String role;
  final String type;
  final List<ImageModel> image;
  final String url;

  ArtistInfo({
    required this.id,
    required this.name,
    required this.role,
    required this.type,
    required this.image,
    required this.url,
  });

  factory ArtistInfo.fromJson(Map<String, dynamic> json) {
    return ArtistInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      type: json['type'] ?? '',
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      url: json['url'] ?? '',
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
}

class ArtistsCollection {
  final List<ArtistInfo> primary;
  final List<ArtistInfo> featured;
  final List<ArtistInfo> all;

  ArtistsCollection({
    required this.primary,
    required this.featured,
    required this.all,
  });

  factory ArtistsCollection.fromJson(Map<String, dynamic> json) {
    return ArtistsCollection(
      primary: (json['primary'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featured: (json['featured'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      all: (json['all'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DownloadUrl {
  final String quality;
  final String url;

  DownloadUrl({
    required this.quality,
    required this.url,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      quality: json['quality'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class DetailedSongModel {
  final String id;
  final String name;
  final String type;
  final String? year;
  final String? releaseDate;
  final int? duration;
  final String? label;
  final bool explicitContent;
  final int? playCount;
  final String language;
  final bool hasLyrics;
  final String? lyricsId;
  final String url;
  final String? copyright;
  final DetailedAlbumInfo album;
  final ArtistsCollection artists;
  final List<ImageModel> image;
  final List<DownloadUrl> downloadUrl;

  DetailedSongModel({
    required this.id,
    required this.name,
    required this.type,
    this.year,
    this.releaseDate,
    this.duration,
    this.label,
    required this.explicitContent,
    this.playCount,
    required this.language,
    required this.hasLyrics,
    this.lyricsId,
    required this.url,
    this.copyright,
    required this.album,
    required this.artists,
    required this.image,
    required this.downloadUrl,
  });

  factory DetailedSongModel.fromJson(Map<String, dynamic> json) {
    return DetailedSongModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      year: json['year'],
      releaseDate: json['releaseDate'],
      duration: json['duration'],
      label: json['label'],
      explicitContent: json['explicitContent'] ?? false,
      playCount: json['playCount'],
      language: json['language'] ?? '',
      hasLyrics: json['hasLyrics'] ?? false,
      lyricsId: json['lyricsId'],
      url: json['url'] ?? '',
      copyright: json['copyright'],
      album: DetailedAlbumInfo.fromJson(json['album'] ?? {}),
      artists: ArtistsCollection.fromJson(json['artists'] ?? {}),
      image: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      downloadUrl: (json['downloadUrl'] as List<dynamic>?)
              ?.map((e) => DownloadUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
  String get primaryArtistsText => artists.primary.map((a) => a.name).join(', ');
  String get allArtistsText => artists.all.map((a) => a.name).join(', ');
  String get durationText {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class SongDetailsResponse {
  final bool success;
  final List<DetailedSongModel> data;

  SongDetailsResponse({
    required this.success,
    required this.data,
  });

  factory SongDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SongDetailsResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DetailedSongModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  DetailedSongModel? get song => data.isNotEmpty ? data.first : null;
}
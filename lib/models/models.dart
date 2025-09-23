// models/image_model.dart
class ImageModel {
  final String quality;
  final String url;

  ImageModel({required this.quality, required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(quality: json['quality'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'quality': quality, 'url': url};
  }
}

// models/search_result_section.dart
class SearchResultSection<T> {
  final List<T> results;
  final int position;

  SearchResultSection({required this.results, required this.position});
}

// models/search_response.dart
class SearchResponse {
  final bool success;
  final SearchResultSection<DetailedSongModel> songs;

  SearchResponse({
    required this.success,
    required this.songs,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return SearchResponse(
      success: json['success'] ?? false,
      songs: SearchResultSection<DetailedSongModel>(
        results:
            (data['results'] as List<dynamic>?)
                ?.map(
                  (e) => DetailedSongModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [],
        position: data['start'] ?? 0,
      ),
    );
  }
}

class DetailedAlbumInfo {
  final String? id;
  final String? name;
  final String? url;

  DetailedAlbumInfo({this.id, this.name, this.url});

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
      image:
          (json['image'] as List<dynamic>?)
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
      primary:
          (json['primary'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featured:
          (json['featured'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      all:
          (json['all'] as List<dynamic>?)
              ?.map((e) => ArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DownloadUrl {
  final String quality;
  final String url;

  DownloadUrl({required this.quality, required this.url});

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(quality: json['quality'] ?? '', url: json['url'] ?? '');
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
      image:
          (json['image'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      downloadUrl:
          (json['downloadUrl'] as List<dynamic>?)
              ?.map((e) => DownloadUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get imageUrl => image.isNotEmpty ? image.last.url : '';
  String get primaryArtistsText =>
      artists.primary.map((a) => a.name).join(', ');
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

  SongDetailsResponse({required this.success, required this.data});

  factory SongDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SongDetailsResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => DetailedSongModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  DetailedSongModel? get song => data.isNotEmpty ? data.first : null;
}

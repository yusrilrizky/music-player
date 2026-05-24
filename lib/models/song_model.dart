import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String audioUrl;
  final String? lyrics;
  final int duration; // in milliseconds
  final int? releaseYear;
  final String? genre;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.audioUrl,
    this.lyrics,
    required this.duration,
    this.releaseYear,
    this.genre,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown Artist',
      album: json['album'] ?? 'Unknown Album',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      lyrics: json['lyrics'],
      duration: json['duration'] ?? 0,
      releaseYear: json['releaseYear'],
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'lyrics': lyrics,
      'duration': duration,
      'releaseYear': releaseYear,
      'genre': genre,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        album,
        imageUrl,
        audioUrl,
        lyrics,
        duration,
        releaseYear,
        genre,
      ];
}

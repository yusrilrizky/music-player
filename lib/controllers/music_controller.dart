import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import '../services/music_service.dart';

class MusicController extends GetxController {
  final MusicService _musicService = MusicService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  RxList<Song> songs = <Song>[].obs;
  RxList<Song> searchResults = <Song>[].obs;
  Rx<Song?> currentSong = Rx<Song?>(null);
  RxBool isPlaying = false.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxDouble currentPosition = 0.0.obs;
  RxDouble duration = 0.0.obs;
  RxInt currentSongIndex = 0.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    _setupAudioPlayer();
    await loadPopularSongs();
  }

  void _setupAudioPlayer() {
    _audioPlayer.positionStream.listen((position) {
      currentPosition.value = position.inMilliseconds.toDouble();
    });

    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur.inMilliseconds.toDouble();
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> loadPopularSongs() async {
    try {
      isLoading.value = true;
      songs.value = await _musicService.getPopularSongs();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchSongs(String query) async {
    try {
      isLoading.value = true;
      searchQuery.value = query;
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        searchResults.value = await _musicService.searchSongs(query);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playSong(Song song) async {
    try {
      currentSong.value = song;
      if (song.audioUrl.isNotEmpty) {
        await _audioPlayer.setUrl(song.audioUrl);
        await _audioPlayer.play();
      } else {
        Get.snackbar('Info', 'Audio preview tidak tersedia');
      }
    } catch (e) {
      errorMessage.value = 'Failed to play song: $e';
      Get.snackbar('Error', errorMessage.value);
    }
  }

  Future<void> pauseSong() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> resumeSong() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> nextSong() async {
    try {
      if (currentSongIndex.value < songs.length - 1) {
        currentSongIndex.value++;
        await playSong(songs[currentSongIndex.value]);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> previousSong() async {
    try {
      if (currentSongIndex.value > 0) {
        currentSongIndex.value--;
        await playSong(songs[currentSongIndex.value]);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> seekTo(double milliseconds) async {
    try {
      await _audioPlayer.seek(Duration(milliseconds: milliseconds.toInt()));
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

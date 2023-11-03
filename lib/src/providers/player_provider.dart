import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';

class PlayerProvider with ChangeNotifier {
  Article? _currentArticle;
  Article? get currentArticle => _currentArticle;

  List<Article>? _listOfArticle;
  List<Article>? get listOfArticle => _listOfArticle;

  // final AudioPlayer _audioPlayer = AudioPlayer();

  // AudioPlayer get audioPlayer => _audioPlayer;

  setPlaylist(List<Article> listOfArticle, int index) async {
    // _listOfArticle = listOfArticle;
    // if (_audioPlayer.playing) {
    //   await _audioPlayer.stop();
    //   _currentArticle = listOfArticle[index];
    //   final playlist = ConcatenatingAudioSource(
    //       children: createPlayListofArticles(listOfArticle) ?? []);
    //   await initAudioPlayer(playlist, index);
    // } else {
    //   _currentArticle = listOfArticle[index];
    //   final playlist = ConcatenatingAudioSource(
    //       children: createPlayListofArticles(listOfArticle) ?? []);
    //   await initAudioPlayer(playlist, index);
    // }
    notifyListeners();
  }

  // Future<void> initAudioPlayer(AudioSource article, int index) async {
  //   await _audioPlayer.setLoopMode(LoopMode.all);
  //   await _audioPlayer.setAudioSource(
  //     article,
  //     initialIndex: index,
  //     initialPosition: Duration.zero,
  //   );
  //   _audioPlayer.play();
  //   notifyListeners();
  // }

  // Future<void> changeSpeedRate(double newRate) async {
  //   await _audioPlayer.setSpeed(newRate);
  // }

  // Stream<PositionData>? get positionDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //       _audioPlayer.positionStream,
  //       _audioPlayer.bufferedPositionStream,
  //       _audioPlayer.durationStream,
  //       (position, bufferPosition, duration) => PositionData(
  //         position,
  //         duration ?? Duration.zero,
  //         bufferPosition,
  //       ),
  //     );

  createPlayListofArticles(List<Article> listOfArticle) {
    // List<AudioSource>? createPlaylist = [];
    // for (var element in listOfArticle) {
    //   Article data = element;
    //   if ((data.writtenText ?? '').isEmpty &&
    //       data.articleType != writtenArticle) {
    //     var user = data.userId == getInt(prefkeyId)
    //         ? getString(prefkeyUserName)
    //         : data.user?.name;
    //     AudioSource source = AudioSource.uri(
    //       Uri.parse(data.recordedFile ?? ''),
    //       tag: MediaItem(
    //         id: '${data.id}',
    //         title: data.title ?? '',
    //         artist: user,
    //         artUri: Uri.parse(data.imageURL?.trim() ?? ''),
    //       ),
    //     );
    //     createPlaylist.add(source);
    //   }
    // }
    // return createPlaylist;
  }

  clearAudioPlayer() {
    _listOfArticle = [];
    // _audioPlayer.stop();
    notifyListeners();
  }

  clearArticle() {
    _currentArticle = null;
    notifyListeners();
  }

  setArticleAsIsLiked(int articleId) {
    _listOfArticle?.map((e) {
          if (e.id == articleId) {
            e.isLiked = e.isLiked == 0 ? 1 : 0;
            return e;
          }
        }).toList() ??
        [];
    notifyListeners();
  }
}

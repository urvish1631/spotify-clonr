import 'package:flutter/foundation.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';
import 'package:sada_app/src/models/playlist/res_playlist_model.dart';

class PlaylistProvider extends ChangeNotifier {
  List<PlaylistModel>? _playlist;
  List<PlaylistModel>? get playlist => _playlist;

  List<Article>? _playlistArticles;
  List<Article>? get playlistArticles => _playlistArticles;

  List<Article>? _categoryArticles;
  List<Article>? get categoryArticles => _categoryArticles;

  List<Article>? _categoryPlaylistArticles;
  List<Article>? get categoryPlaylistArticles => _categoryPlaylistArticles;

  PlaylistModel? _currentPlaylistModel;
  PlaylistModel? get getCurrentPlaylist => _currentPlaylistModel;

  bool _isApiCalled = false;
  bool get isApiCalled {
    return _isApiCalled;
  }

  addPlaylist(List<PlaylistModel>? playlist) {
    _playlist = playlist;
    _isApiCalled = true;
    notifyListeners();
  }

  addCreatedPlaylist(PlaylistModel playlist) {
    _playlist?.add(playlist);
    _isApiCalled = true;
    notifyListeners();
  }

  addPlaylistArticles(List<Article>? playlist) {
    _playlistArticles = createArticleData(playlist);
    _isApiCalled = true;
    notifyListeners();
  }

  addCategoriesArticles(List<Article>? playlist) {
    _categoryArticles = createArticleData(playlist);
    _isApiCalled = true;
    notifyListeners();
  }

  updatePlaylistData(PlaylistModel model) {
    PlaylistModel oldData =
        _playlist?.firstWhere((element) => element.id == model.id) ??
            PlaylistModel();
    oldData = model;
    _playlist?.map(
      (element) => {
        if (element.id == model.id) {element = oldData},
      },
    );
    _currentPlaylistModel = model;
    notifyListeners();
  }

  setCurrentPlaylistData(int id) {
    _currentPlaylistModel =
        _playlist?.firstWhere((element) => element.id == id);
    notifyListeners();
  }

  createArticleData(List<Article>? playlist) {
    List<Article> newData = [];
    for (Article element in playlist ?? []) {
      Article el = element.article ?? Article();
      newData.add(el);
    }
    return newData;
  }

  clearData() {
    _isApiCalled = false;
    _categoryArticles = [];
    _playlistArticles = [];
    notifyListeners();
  }
}

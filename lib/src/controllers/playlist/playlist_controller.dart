import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/apis/apimanagers/playlist_api_manager.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/models/playlist/req_playlist_model.dart';
import 'package:spotify_clone/src/models/playlist/res_playlist_model.dart';
import 'package:spotify_clone/src/providers/playlist_provider.dart';
import 'package:spotify_clone/src/widgets/toast_widget.dart';

class PlaylistController {
  Future<void> createPlaylistApi(
      {required BuildContext context, required ReqPlaylistModel model}) async {
    await locator<PlaylistApiManger>().createPlaylist(model).then(
      (data) {
        Provider.of<PlaylistProvider>(context, listen: false)
            .addCreatedPlaylist(data.data ?? PlaylistModel());
        ToastUtils.showSuccess(message: data.msg ?? '');
        locator<NavigationUtils>().pop();
      },
    );
  }

  Future<void> updatePlaylistApi(
      {required BuildContext context,
      required ReqPlaylistModel model,
      required int playlistId}) async {
    await locator<PlaylistApiManger>().updatePlaylist(model, playlistId).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
        Provider.of<PlaylistProvider>(context, listen: false)
            .updatePlaylistData(data.data ?? PlaylistModel());
        listOfPlaylistApi(context: context);
        locator<NavigationUtils>().pop();
      },
    );
  }

  Future<void> deletePlaylistApi(
      {required BuildContext context, required int playlistId}) async {
    await locator<PlaylistApiManger>().deletePlaylist(playlistId).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  Future<void> listOfPlaylistApi({required BuildContext context}) async {
    await locator<PlaylistApiManger>().getPlaylist().then(
      (data) {
        Provider.of<PlaylistProvider>(context, listen: false)
            .addPlaylist(data.data);
      },
    );
  }

  Future<void> getPlaylistArticlesApi(
      {required BuildContext context, required int playlistId}) async {
    await locator<PlaylistApiManger>().getPlaylistArticle(playlistId).then(
      (data) {
        Provider.of<PlaylistProvider>(context, listen: false)
            .addPlaylistArticles(data.data);
      },
    );
  }

  Future<void> addArticleInPlaylistApi(
      {required BuildContext context,
      required int playlistId,
      required int articleId}) async {
    await locator<PlaylistApiManger>()
        .addArticlePlaylist(playlistId, articleId)
        .then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
        locator<NavigationUtils>().pop();
      },
    );
  }

  Future<void> removeArticlePlaylistApi(
      {required BuildContext context,
      required int playlistId,
      required int articleId}) async {
    await locator<PlaylistApiManger>()
        .removeArticlePlaylist(playlistId, articleId)
        .then(
      (data) {
        getPlaylistArticlesApi(context: context, playlistId: playlistId);
      },
    );
  }
}

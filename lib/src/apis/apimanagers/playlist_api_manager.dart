import 'package:sada_app/src/apis/api_route_constant.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/models/playlist/req_playlist_model.dart';
import 'package:sada_app/src/models/playlist/res_playlist_model.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';
import 'package:sada_app/src/models/res_base_model.dart';

class PlaylistApiManger {
  Future<ResPlaylistModel> createPlaylist(ReqPlaylistModel model) async {
    final response = await locator<ApiService>().post(
      apiCreatePlaylist,
      data: model.toJson(),
    );
    return ResPlaylistModel.fromJson(response!.data);
  }

  Future<ResPlaylistModel> updatePlaylist(
      ReqPlaylistModel model, int id) async {
    final response = await locator<ApiService>().post(
      apiEditDeletePlaylist(id),
      data: model.toJson(),
    );
    return ResPlaylistModel.fromJson(response!.data);
  }

  Future<ResPlaylistModel> deletePlaylist(int id) async {
    final response =
        await locator<ApiService>().delete(apiEditDeletePlaylist(id));
    return ResPlaylistModel.fromJson(response!.data);
  }

  Future<ResRecommendationModel> getPlaylistArticle(int id) async {
    final response = await locator<ApiService>().get(
      apiGetPlaylistArticle(id),
    );
    return ResRecommendationModel.fromJson(response!.data);
  }

  Future<ResGetPlaylistModel> getPlaylist() async {
    final response = await locator<ApiService>().get(
      apiCreatePlaylist,
    );
    return ResGetPlaylistModel.fromJson(response!.data);
  }

  Future<ResBaseModel> addArticlePlaylist(int id, int articleId) async {
    final response = await locator<ApiService>().post(
      apiArticlePlaylist(id, articleId, true),
    );
    return ResBaseModel.fromJson(response!.data);
  }

  Future<ResBaseModel> removeArticlePlaylist(int id, int articleId) async {
    final response = await locator<ApiService>().delete(
      apiArticlePlaylist(id, articleId, false),
    );
    return ResBaseModel.fromJson(response!.data);
  }
}

import 'package:sada_app/src/apis/api_route_constant.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/dic_params.dart';
import 'package:sada_app/src/models/articles/req_recommendation_model.dart';
import 'package:sada_app/src/models/articles/res_article_model.dart';
import 'package:sada_app/src/models/articles/res_recently_played_model.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';
import 'package:sada_app/src/models/auth/language/req_language_model.dart';
import 'package:sada_app/src/models/auth/language/res_language_model.dart';
import 'package:sada_app/src/models/category/res_category_model.dart';
import 'package:sada_app/src/models/category/res_category_wise_model.dart';
import 'package:sada_app/src/models/playlist/res_playlist_model.dart';
import 'package:sada_app/src/models/res_base_model.dart';

class HomeApiManager {
  Future<ResRecommendationModel> getRecommendations(
      ReqRecommendationModel model, int page) async {
    final response = await locator<ApiService>().post(
      apiRecommendations,
      data: model.toJson(),
      params: {paramPage: page, paramLimit: 10},
    );
    return ResRecommendationModel.fromJson(response?.data);
  }

  Future<ResCategoriesModel> getCategories(int page) async {
    final response = await locator<ApiService>().get(apiCategory, params: {
      paramPage: page,
      paramLimit: 20,
    });
    return ResCategoriesModel.fromJson(response?.data);
  }

  Future<ResArticlesModel> getArticles(int page) async {
    final response = await locator<ApiService>().get(apiArticle, params: {
      paramPage: page,
      paramLimit: 20,
    });
    return ResArticlesModel.fromJson(response?.data);
  }

  Future<ResCategoriesModel> getArtists(int page) async {
    final response = await locator<ApiService>().get(apiGetArtist, params: {
      paramPage: page,
      paramLimit: 20,
    });
    return ResCategoriesModel.fromJson(response?.data);
  }

  Future<ResRecentlyPlayedModel> getRecentlyPlayed() async {
    final response = await locator<ApiService>().get(
      apiRecentlyPlayed,
    );
    return ResRecentlyPlayedModel.fromJson(response?.data);
  }

  Future<ResPlaylistModel> recentPlayedTrack(int id) async {
    final response = await locator<ApiService>().post(apiTrackPlayer(id));
    return ResPlaylistModel.fromJson(response!.data);
  }

  Future<ResCategoryWiseModel> getArticlesByCategory(int id) async {
    final response = await locator<ApiService>().get(
      apiArticleByCategory(id),
    );
    return ResCategoryWiseModel.fromJson(response!.data);
  }

  Future<ResCategoriesModel> getAllCategories() async {
    final response = await locator<ApiService>().get(
      apiAllCategory,
    );
    return ResCategoriesModel.fromJson(response!.data);
  }

  Future<ResBaseModel> followCreator(int id) async {
    final response = await locator<ApiService>().post(apiFollowCreator(id));
    return ResBaseModel.fromJson(response!.data);
  }

  Future<ResLanguageModel> changeLanguage(ReqLanguageModel model) async {
    final response = await locator<ApiService>()
        .post(apiChangeLanguage, data: model.toJson());
    return ResLanguageModel.fromJson(response!.data);
  }
}

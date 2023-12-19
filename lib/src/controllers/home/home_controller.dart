import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/apis/apimanagers/home_api_manager.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/main.dart';
import 'package:spotify_clone/src/models/articles/req_recommendation_model.dart';
import 'package:spotify_clone/src/models/auth/language/req_language_model.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/language_provider.dart';
import 'package:spotify_clone/src/providers/playlist_provider.dart';
import 'package:spotify_clone/src/widgets/toast_widget.dart';

class HomeController {
  Future<void> getRecommendationsApi(
      {required BuildContext context,
      required int page,
      required ReqRecommendationModel model}) async {
    await locator<HomeApiManager>().getRecommendations(model, page).then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addRecommendations(data.data ?? []);
      },
    );
  }

  Future<void> getArticlesApi(
      {required BuildContext context, required int page}) async {
    await locator<HomeApiManager>().getArticles(page).then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addArticleList(data.data ?? []);
      },
    );
  }

  Future<void> recentPlayedTrack(
      {required BuildContext context, required int id}) async {
    await locator<HomeApiManager>().recentPlayedTrack(id);
  }

  Future<void> getArtistApi(
      {required BuildContext context, required int page}) async {
    await locator<HomeApiManager>().getArtists(page).then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addArtistList(data.data ?? []);
      },
    );
  }

  Future<void> getCategoriesApi(
      {required BuildContext context, required int page}) async {
    await locator<HomeApiManager>().getCategories(page).then(
      (ResCategoriesModel data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addCategoriesList(data.data ?? []);
      },
    );
  }

  Future<void> recentlyPlayedApi({required BuildContext context}) async {
    await locator<HomeApiManager>().getRecentlyPlayed().then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addRecentlyPlayed(data.data);
      },
    );
  }

  Future<void> getAllCategoriesApi({required BuildContext context}) async {
    await locator<HomeApiManager>().getAllCategories().then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .allCategoriesList(data);
      },
    );
  }

  Future<void> getArticlesByCategoryIdApi(
      {required BuildContext context, required int categoryId}) async {
    await locator<HomeApiManager>().getArticlesByCategory(categoryId).then(
      (data) {
        Provider.of<PlaylistProvider>(context, listen: false)
            .addCategoriesArticles(data.data);
      },
    );
  }

  Future<void> followTheCreatorApi(
      {required BuildContext context, required int artistId}) async {
    await locator<HomeApiManager>().followCreator(artistId).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '', duration: 2);
        Provider.of<ArticlesProvider>(context, listen: false).artistClearPage();
        getArtistApi(context: context, page: 1);
      },
    );
  }

  Future<void> changeLanguageApi(
      {required BuildContext context, required ReqLanguageModel model}) async {
    await locator<HomeApiManager>().changeLanguage(model).then(
      (data) {
        if ((data.user?.languagePref ?? '') == english) {
          Provider.of<LanguageProvider>(context, listen: false)
              .changeLanguage(const Locale(en));
          RestartWidget.restartApp(context);
        } else if ((data.user?.languagePref ?? '') == arabic) {
          Provider.of<LanguageProvider>(context, listen: false)
              .changeLanguage(const Locale(ar));
          RestartWidget.restartApp(context);
        }
      },
    );
  }
}

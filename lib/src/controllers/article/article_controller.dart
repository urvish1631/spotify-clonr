import 'package:spotify_clone/src/apis/apimanagers/article_api_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/models/articles/req_article_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/bottom_tabbar_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/providers/search_provider.dart';
import 'package:spotify_clone/src/widgets/toast_widget.dart';

class ArticleController {
  Future<void> createArticleApi(
      {required BuildContext context, required ReqArticleModel model}) async {
    await locator<ArticleApiManager>().createArticle(model).then(
      (data) {
        Provider.of<BottomTabBarProvider>(context, listen: false).setIndex(0);
        locator<NavigationUtils>().pushAndRemoveUntil(routeTabBar);
      },
    );
  }

  Future<void> updateArticleApi(
      {required BuildContext context,
      required ReqArticleModel model,
      required int id}) async {
    await locator<ArticleApiManager>().updateArticle(model, id).then(
      (data) {
        Provider.of<BottomTabBarProvider>(context, listen: false).setIndex(3);
        locator<NavigationUtils>().pushAndRemoveUntil(routeTabBar);
      },
    );
  }

  Future<void> searchQueryApi(
      {required BuildContext context, required String text}) async {
    await locator<ArticleApiManager>().searchQuery(text).then(
      (data) {
        Provider.of<SearchProvider>(context, listen: false).addSearchData(data);
      },
    );
  }

  Future<void> deleteArticleApi(
      {required BuildContext context, required int articleId}) async {
    await locator<ArticleApiManager>().deleteArticle(articleId).then(
      (data) {
        if (getBool(prefkeyIsCreator)) {
          locator<AuthController>()
              .getCreatorProfile(context: context, id: getInt(prefkeyId));
        } else {
          locator<AuthController>().getUserProfile(context: context);
        }
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  Future<void> getArticleById(
      {required BuildContext context, required int id}) async {
    await locator<ArticleApiManager>().getArticleById(id).then(
      (data) {
        Provider.of<ArticlesProvider>(context, listen: false)
            .addSingleArticle(data.data);
      },
    );
  }

  Future<void> likeArticleApi(
      {required BuildContext context, required int articleId}) async {
    await locator<ArticleApiManager>().likeArticle(articleId).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
        Provider.of<PlayerProvider>(context, listen: false)
            .setArticleAsIsLiked(articleId);
      },
    );
  }
}

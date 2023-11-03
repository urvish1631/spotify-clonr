import 'package:sada_app/src/apis/api_route_constant.dart';
import 'package:sada_app/src/models/res_base_model.dart';
import 'package:sada_app/src/models/search/res_search_model.dart';
import 'package:sada_app/src/models/articles/req_article_model.dart';
import 'package:sada_app/src/models/articles/res_get_article_model.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/dic_params.dart';

class ArticleApiManager {
  Future<ResBaseModel> createArticle(ReqArticleModel model) async {
    final response = await locator<ApiService>()
        .post(apiCreateArticle, data: model.toJson());
    return ResBaseModel.fromJson(response!.data);
  }

  Future<ResBaseModel> updateArticle(ReqArticleModel model, int id) async {
    final response = await locator<ApiService>()
        .post(apiUpdateArticle(id), data: model.toJson());
    return ResBaseModel.fromJson(response!.data);
  }

  Future<ResSingleArticlesModel> getArticleById(int id) async {
    final response = await locator<ApiService>().get(
      apiUpdateArticle(id),
    );
    return ResSingleArticlesModel.fromJson(response!.data);
  }

  Future<ResBaseModel> deleteArticle(int id) async {
    final response = await locator<ApiService>().delete(
      apiDeletArticle(id),
    );
    return ResBaseModel.fromJson(response!.data);
  }

  Future<ResSearchModel> searchQuery(String text) async {
    final response = await locator<ApiService>()
        .get(apiSearchQuery, params: {paramQuery: text});
    return ResSearchModel.fromJson(response!.data);
  }

  Future<ResBaseModel> likeArticle(int id) async {
    final response = await locator<ApiService>().post(apiLikeArticle(id));
    return ResBaseModel.fromJson(response!.data);
  }
}

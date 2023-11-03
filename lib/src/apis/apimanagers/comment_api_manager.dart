import 'package:sada_app/src/apis/api_route_constant.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/dic_params.dart';
import 'package:sada_app/src/models/comment/req_comment_model.dart';
import 'package:sada_app/src/models/comment/res_comment_model.dart';

class CommentApiManager {
  Future<ResCreatedCommentModel> createComment(
      ReqCommentSectionModel model, int articleId) async {
    final response = await locator<ApiService>()
        .post(apiCreateComment(articleId), data: model.toJson());
    return ResCreatedCommentModel.fromJson(response?.data);
  }

  Future<ResCommentSectionModel> getListofCommentsArticle(
      int articleId, int page) async {
    final response = await locator<ApiService>()
        .get(apiGetArticleComments(articleId), params: {
      paramPage: page,
      paramLimit: 20,
    });
    return ResCommentSectionModel.fromJson(response?.data);
  }

  Future<ResCommentSectionModel> deleteComment(int commentId) async {
    final response = await locator<ApiService>().delete(
      apiCreateComment(commentId),
    );
    return ResCommentSectionModel.fromJson(response?.data);
  }
}

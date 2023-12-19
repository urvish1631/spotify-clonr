import 'package:spotify_clone/src/apis/api_route_constant.dart';
import 'package:spotify_clone/src/apis/api_service.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/models/comment/req_comment_model.dart';
import 'package:spotify_clone/src/models/comment/res_comment_model.dart';

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

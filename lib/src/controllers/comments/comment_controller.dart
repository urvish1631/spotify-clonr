import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/apis/apimanagers/comment_api_manager.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/models/comment/req_comment_model.dart';
import 'package:sada_app/src/providers/comment_provider.dart';
import 'package:sada_app/src/widgets/toast_widget.dart';

class CommentController {
  Future<void> createCommentOfArticle(
      {required BuildContext context,
      required ReqCommentSectionModel model,
      required int articleId}) async {
    await locator<CommentApiManager>().createComment(model, articleId).then(
      (data) {
        getAllComments(context: context, articleId: articleId, page: 1);
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  Future<void> deleteComment(
      {required BuildContext context,
      required int commentId,
      required int articleId}) async {
    await locator<CommentApiManager>().deleteComment(commentId).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
        getAllComments(context: context, articleId: articleId, page: 1);
      },
    );
  }

  Future<void> getAllComments(
      {required BuildContext context,
      required int articleId,
      required int page}) async {
    await locator<CommentApiManager>()
        .getListofCommentsArticle(articleId, page)
        .then(
      (data) {
        Provider.of<CommentProvider>(context, listen: false)
            .addArticleComments(data);
      },
    );
  }
}

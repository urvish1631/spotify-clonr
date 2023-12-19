import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/ui/record_audio/write_article.dart';

class UpdateWrittenArticleScreen extends StatefulWidget {
  final Article? articleData;
  final bool? isWritten;
  const UpdateWrittenArticleScreen(
      {Key? key, this.articleData, this.isWritten = false})
      : super(key: key);

  @override
  State<UpdateWrittenArticleScreen> createState() =>
      _UpdateWrittenArticleScreenState();
}

class _UpdateWrittenArticleScreenState
    extends State<UpdateWrittenArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return WriteArticleScreen(
      fromProfile: true,
      isWritten: widget.isWritten,
      articleData: widget.articleData,
    ).authContainerScaffold(
      context: context,
      isLeadingEnable: true,
      isTitleEnable: true,
      title: widget.isWritten ?? false
          ? Localization.of().article
          : Localization.of().update,
    );
  }
}

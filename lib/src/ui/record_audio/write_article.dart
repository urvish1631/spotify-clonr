import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/string_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/primary_text_field.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class WriteArticleScreen extends StatefulWidget {
  final Article? articleData;
  final bool? fromProfile;
  final bool? isWritten;

  const WriteArticleScreen({
    Key? key,
    this.articleData,
    this.isWritten,
    this.fromProfile,
  }) : super(key: key);

  @override
  State<WriteArticleScreen> createState() => _WriteArticleScreenState();
}

class _WriteArticleScreenState extends State<WriteArticleScreen> {
  final _articleController = TextEditingController();
  final _articleFocus = FocusNode();

  @override
  initState() {
    _articleController.text = widget.articleData?.writtenText ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: (widget.isWritten) ?? false
          ? Container(
              height: 400,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: secondaryColor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ThemeText(
                    text: widget.articleData?.writtenText ?? '',
                    lightTextColor: whiteColor,
                    fontSize: fontSize18,
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                _getArticleTextField(),
                const SizedBox(height: 10),
                _getSubmitButton(),
              ],
            ),
    );
  }

  // Widgets
  Widget _getArticleTextField() {
    return PrimaryTextField(
      enabled: true,
      hint: Localization.of().writeArticleHere,
      focusNode: _articleFocus,
      maxLines: 15,
      maxLength: 400,
      type: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      controller: _articleController,
      onFieldSubmitted: (value) {
        _articleFocus.unfocus();
      },
      validateFunction: (value) {
        return value!.isFieldEmpty(Localization.of().msgWrittenArticleEmpty);
      },
    );
  }

  Widget _getSubmitButton() {
    return PrimaryButton(
      buttonText: widget.fromProfile ?? false
          ? Localization.of().update
          : Localization.of().submit,
      buttonColor: primaryColor,
      onButtonClick: () {
        locator<NavigationUtils>().push(
          routePublishArticle,
          arguments: {
            paramArticleRecorded: false,
            paramFromProfile: widget.fromProfile ?? false,
            paramWrittenArticle: _articleController.text,
            paramArticleData:
                widget.fromProfile ?? false ? widget.articleData : null,
            paramArticleId: widget.articleData?.id,
          },
        );
      },
    );
  }
}

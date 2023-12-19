import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class PrimaryListTileWidget extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final void Function()? onListTileClick;
  final String? imageUrl;
  final Widget? endIcon;
  final bool isArticle;
  final bool isCategory;
  const PrimaryListTileWidget({
    Key? key,
    this.title,
    required this.imageUrl,
    this.subTitle,
    this.endIcon,
    this.isCategory = false,
    required this.isArticle,
    this.onListTileClick,
  }) : super(key: key);
  @override
  State<PrimaryListTileWidget> createState() => _PrimaryListTileWidgetState();
}

class _PrimaryListTileWidgetState extends State<PrimaryListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onListTileClick,
      child: Padding(
        padding: (widget.subTitle ?? '').isNotEmpty
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 5.0),
        child: ListTile(
          leading: (widget.imageUrl ?? "").isNotEmpty
              ? ProfileImageView(
                  imageUrl: widget.imageUrl ?? '',
                  size: 50,
                )
              : ProfileImageView(
                  imageUrl: (widget.isArticle)
                      ? dummyArticleImage
                      : (widget.isCategory)
                          ? dummyCategoryImage
                          : dummyImage,
                  size: 50,
                ),
          title: ThemeText(
            text: widget.title ?? '',
            lightTextColor: whiteColor,
            fontSize: fontSize18,
            fontWeight: fontWeightBold,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: (widget.subTitle ?? '').isNotEmpty
              ? ThemeText(
                  text: widget.subTitle ?? '',
                  lightTextColor: whiteColor,
                  fontSize: fontSize14,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: widget.endIcon,
        ),
      ),
    );
  }
}

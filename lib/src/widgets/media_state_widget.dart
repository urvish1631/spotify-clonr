import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/context_extension.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/dic_params.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/controllers/article/article_controller.dart';
import 'package:sada_app/src/providers/player_provider.dart';
import 'package:sada_app/src/widgets/shimmer_widget.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class MediaState extends StatefulWidget {
  final String title;
  final String id;
  final String artist;
  final String imageUrl;
  final int index;
  const MediaState(
      {Key? key,
      required this.title,
      required this.id,
      this.index = 0,
      required this.artist,
      required this.imageUrl})
      : super(key: key);

  @override
  State<MediaState> createState() => _MediaStateState();
}

class _MediaStateState extends State<MediaState> {
  //Variables
  bool? isLiked;

  //Function
  _likeArticle() {
    locator<ArticleController>()
        .likeArticleApi(context: context, articleId: int.parse(widget.id));
  }

  //Build methods
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: context.getHeight(0.5),
            width: context.getWidth(),
            child: SizedBox(
              width: context.getWidth() / context.getHeight(),
              height: context.getWidth() / context.getHeight(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl.isEmpty
                      ? dummyArticleImage
                      : widget.imageUrl.trim(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ShimmerWidget(
                    width: context.getWidth() / context.getHeight(),
                    height: context.getWidth() / context.getHeight(),
                  ),
                  errorWidget: (context, url, error) => Container(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.getWidth(0.55),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThemeText(
                      text: widget.title,
                      lightTextColor: whiteColor,
                      fontSize: fontSize22,
                      fontWeight: fontWeightBold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    ThemeText(
                      text: widget.artist,
                      lightTextColor: whiteColor,
                      fontSize: fontSize18,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              Consumer<PlayerProvider>(
                  builder: (context, playerProvider, child) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => _likeArticle(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          icLike,
                          colorFilter: playerProvider
                                      .listOfArticle?[widget.index].isLiked ==
                                  1
                              ? const ColorFilter.mode(
                                  primaryColor, BlendMode.srcIn)
                              : const ColorFilter.mode(
                                  whiteColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => locator<NavigationUtils>().push(
                        routeComments,
                        arguments: {
                          paramArticleId: int.parse(widget.id),
                        },
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.forum_rounded,
                          color: whiteColor,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}

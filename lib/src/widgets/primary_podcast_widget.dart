import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/widgets/shimmer_widget.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class DisplayPodcastWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final String? subTitle;
  final double? imageHeight;
  const DisplayPodcastWidget({
    Key? key,
    this.image,
    this.title,
    this.subTitle,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: image == null || (image ?? '').isEmpty
                  ? dummyArticleImage
                  : (image ?? "").trim(),
              fit: BoxFit.cover,
              height: imageHeight,
              width: imageHeight,
              errorWidget: (context, url, error) => Container(),
              placeholder: (context, url) => ShimmerWidget(
                height: imageHeight ?? 0,
                width: imageHeight ?? 0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemeText(
                text: title ?? "",
                lightTextColor: whiteColor,
                fontSize: fontSize16,
                fontWeight: fontWeightBold,
                overflow: TextOverflow.ellipsis,
              ),
              ThemeText(
                text: subTitle ?? '',
                lightTextColor: whiteColor,
                fontSize: fontSize14,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}

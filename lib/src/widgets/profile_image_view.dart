import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sada_app/src/widgets/shimmer_widget.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfileImageView({Key? key, required this.imageUrl, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl.trim(),
          fit: BoxFit.cover,
          placeholder: (context, url) => ShimmerWidget(
            height: size,
            width: size,
          ),
          errorWidget: (context, url, error) => Container(),
        ),
      ),
    );
  }
}

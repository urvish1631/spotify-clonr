import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class GridSkeletonView extends StatelessWidget {
  final double height;
  const GridSkeletonView({Key? key, this.height = 144.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Shimmer.fromColors(
        baseColor: themeData.isDarkMode ? blackColor : Colors.grey[300]!,
        highlightColor: themeData.isDarkMode ? Colors.grey : Colors.grey[100]!,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
          ),
          itemCount: 8,
          shrinkWrap: true,
          itemBuilder: (context, index) => ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                ),
                height: context.getHeight(0.17),
                width: 180,
              ),
              const SizedBox(height: 5),
              Container(
                width: context.getWidth(0.1),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalSkeletonView extends StatelessWidget {
  final double height;
  const HorizontalSkeletonView({Key? key, this.height = 144.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Shimmer.fromColors(
        baseColor: themeData.isDarkMode ? blackColor : Colors.grey[300]!,
        highlightColor: themeData.isDarkMode ? Colors.grey : Colors.grey[100]!,
        child: SizedBox(
          height: height,
          child: ListView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    height: height,
                    width: height,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: height,
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: height,
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

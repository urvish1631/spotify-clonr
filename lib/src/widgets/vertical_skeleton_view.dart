import 'package:flutter/material.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class VerticalSkeletonView extends StatelessWidget {
  final double height;
  final double hPadding;
  const VerticalSkeletonView(
      {Key? key, this.height = 144.0, this.hPadding = 15.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Shimmer.fromColors(
        baseColor: themeData.isDarkMode ? blackColor : Colors.grey[300]!,
        highlightColor: themeData.isDarkMode ? Colors.grey : Colors.grey[100]!,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          itemCount: 8,
          shrinkWrap: true,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ListTile(
              title: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 13.0, 20.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                height: 30,
              ),
              leading:
                  const CircleAvatar(radius: 30, backgroundColor: whiteColor),
              subtitle: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 13.0, 20.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

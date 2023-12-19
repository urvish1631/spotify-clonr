import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSkeletonView extends StatelessWidget {
  const ProfileSkeletonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Shimmer.fromColors(
        baseColor: themeData.isDarkMode ? blackColor : Colors.grey[300]!,
        highlightColor: themeData.isDarkMode ? Colors.grey : Colors.grey[100]!,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 360.0,
              width: context.getWidth(),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
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
                  leading: const CircleAvatar(
                      radius: 30, backgroundColor: whiteColor),
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
          ],
        ),
      ),
    );
  }
}

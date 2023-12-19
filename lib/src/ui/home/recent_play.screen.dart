import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/widgets/primary_list_tile_widget.dart';
import 'package:spotify_clone/src/widgets/vertical_skeleton_view.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  //Lifecycle methods
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRecentlyPlayed();
    });
    super.initState();
  }

  //API calling functions
  getRecentlyPlayed() async {
    await locator<HomeController>().recentlyPlayedApi(context: context);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesProvider>(
      builder: (context, recentlyPlayed, child) {
        var recentData = recentlyPlayed.categoryPlaylistArticles;
        return recentlyPlayed.isApiCalled == false
            ? const VerticalSkeletonView(
                height: 100,
                hPadding: 16,
              )
            : (recentlyPlayed.categoryPlaylistArticles ?? []).isEmpty
                ? getEmptyTextWidget(
                    text: Localization.of().noRecentPlayArticle)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    itemCount: recentData?.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => PrimaryListTileWidget(
                        imageUrl: recentData?[index].imageURL,
                        isArticle: true,
                        title: recentData?[index].title ?? '',
                        subTitle: recentData?[index].user?.name ?? '',
                        onListTileClick: () {
                          Provider.of<PlayerProvider>(context, listen: false)
                              .setPlaylist(recentData ?? [], index);
                          locator<NavigationUtils>().push(routeAudioPlayer);
                        }),
                  );
      },
    ).tabBarScreenScaffold(
      context: context,
      isRecentlyPlayed: true,
      headerTitle: Localization.of().recent,
    );
  }
}

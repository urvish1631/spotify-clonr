import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/context_extension.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/dic_params.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/controllers/playlist/playlist_controller.dart';
import 'package:sada_app/src/providers/playlist_provider.dart';
import 'package:sada_app/src/widgets/grid_skeleton_view.dart';
import 'package:sada_app/src/widgets/shimmer_widget.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  //API functions
  _getListOfPlaylist() async {
    await locator<PlaylistController>().listOfPlaylistApi(context: context);
  }

  //Lifecycle methods
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getListOfPlaylist();
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, right: 18.0, left: 18.0),
      child: Consumer<PlaylistProvider>(
        builder: (context, playlistProvider, child) {
          var playlistData = playlistProvider.playlist;
          return playlistProvider.isApiCalled == false
              ? const GridSkeletonView()
              : (playlistData ?? []).isEmpty
                  ? getEmptyTextWidget(
                      text: Localization.of().noPlaylistMessage)
                  : RefreshIndicator(
                      key: _refreshKey,
                      onRefresh: () => _getListOfPlaylist(),
                      color: primaryColor,
                      child: GridView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          crossAxisCount: 2,
                        ),
                        itemCount: playlistProvider.playlist?.length,
                        padding: const EdgeInsets.only(bottom: 50.0),
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                locator<NavigationUtils>().push(
                                  routeDisplayPlaylist,
                                  arguments: {
                                    paramFromPlaylistData:
                                        playlistProvider.playlist?[index],
                                    paramFromPlayList: true,
                                  },
                                );
                                Provider.of<PlaylistProvider>(context,
                                        listen: false)
                                    .setCurrentPlaylistData(
                                        playlistProvider.playlist?[index].id ??
                                            0);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  playlistProvider.playlist?[index].imageURL ==
                                              null ||
                                          (playlistProvider.playlist?[index]
                                                      .imageURL ??
                                                  '')
                                              .isEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl: dummyArticleImage,
                                            fit: BoxFit.cover,
                                            height: context.getHeight(0.15),
                                            width: 180,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget(
                                              height: 130,
                                              width: 130,
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl: playlistProvider
                                                    .playlist?[index].imageURL
                                                    ?.trim() ??
                                                '',
                                            fit: BoxFit.cover,
                                            height: context.getHeight(0.15),
                                            width: 180,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget(
                                              height: 130,
                                              width: 130,
                                            ),
                                          ),
                                        ),
                                  const SizedBox(height: 5),
                                  ThemeText(
                                    text: playlistProvider
                                            .playlist?[index].name ??
                                        "",
                                    lightTextColor: whiteColor,
                                    fontSize: fontSize16,
                                    fontWeight: fontWeightBold,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ));
                        },
                      ),
                    );
        },
      ),
    ).tabBarScreenScaffold(
      onRightIconClick: () => getPlaylistActions(
        context: context,
        isUpdateTrue: false,
      ),
      context: context,
      isRecentlyPlayed: false,
      headerTitle: Localization.of().playList,
    );
  }
}

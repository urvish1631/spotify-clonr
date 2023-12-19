import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/controllers/playlist/playlist_controller.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';
import 'package:spotify_clone/src/models/playlist/req_playlist_model.dart';
import 'package:spotify_clone/src/models/playlist/res_playlist_model.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/providers/playlist_provider.dart';
import 'package:spotify_clone/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:spotify_clone/src/widgets/customdialogs/material_error_dialog.dart';
import 'package:spotify_clone/src/widgets/popmenu_widget.dart';
import 'package:spotify_clone/src/widgets/primary_list_tile_widget.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';
import 'package:spotify_clone/src/widgets/vertical_skeleton_view.dart';

class DisplayPlaylistScreen extends StatefulWidget {
  final CategoryModel? playlistData;
  final PlaylistModel? fromPlaylistData;
  final bool? fromPlaylist;
  const DisplayPlaylistScreen(
      {Key? key, this.playlistData, this.fromPlaylistData, this.fromPlaylist})
      : super(key: key);

  @override
  State<DisplayPlaylistScreen> createState() => _DisplayPlaylistScreenState();
}

class _DisplayPlaylistScreenState extends State<DisplayPlaylistScreen> {
  //Variables
  int? playlistId;
  PlaylistModel? playlistTitle;
  bool? isApiCalled = true;

  //API functions
  listOfPlaylistArticles(int? id) async {
    await locator<PlaylistController>().getPlaylistArticlesApi(
      context: context,
      playlistId: id ?? 0,
    );
    setState(() {
      isApiCalled = !(isApiCalled ?? false);
    });
  }

  categoryPlaylistArticles(int? id) async {
    await locator<HomeController>().getArticlesByCategoryIdApi(
      context: context,
      categoryId: id ?? 0,
    );
    setState(() {
      isApiCalled = !(isApiCalled ?? false);
    });
  }

  _removeFromPlaylist(int? playlistId, int? articleId) async {
    await locator<PlaylistController>().removeArticlePlaylistApi(
      context: context,
      playlistId: playlistId ?? 0,
      articleId: articleId ?? 0,
    );
  }

  //Life cycle methods
  @override
  void initState() {
    playlistTitle = Provider.of<PlaylistProvider>(context, listen: false)
        .getCurrentPlaylist;
    playlistId = (widget.fromPlaylist ?? false)
        ? playlistTitle?.id
        : widget.playlistData?.id;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.fromPlaylist ?? false) {
        listOfPlaylistArticles(playlistId);
      } else {
        categoryPlaylistArticles(playlistId);
      }
    });
    super.initState();
  }

  //Build methods
  @override
  Widget build(BuildContext context) {
    return (widget.fromPlaylist ?? false)
        ? _getPlaylistData()
        : _getCategoryData();
  }

  // Scaffolds
  Widget _getPlaylistData() => Consumer<PlaylistProvider>(
        builder: (context, playlistData, child) {
          playlistTitle = playlistData.getCurrentPlaylist ?? PlaylistModel();
          return playlistData.isApiCalled == false
              ? const VerticalSkeletonView(
                  height: 100,
                  hPadding: 16,
                )
              : (playlistData.playlistArticles ?? []).isEmpty &&
                      !(isApiCalled ?? false)
                  ? getEmptyTextWidget(
                          text: Localization.of().msgNoArticlesInPlaylist)
                      .titleScaffold(
                      context: context,
                      isTopRequired: false,
                      appBar: AppBar(
                        centerTitle: true,
                        actions: [
                          PopupMenuButton<int>(
                            icon: SvgPicture.asset(
                              icMore,
                              height: 20,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: PopupTextButton(
                                    text: Localization.of().edit),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: PopupTextButton(
                                    text: Localization.of().delete),
                              ),
                            ],
                            offset: const Offset(0, 0),
                            color: secondaryColor,
                            elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                getPlaylistActions(
                                  context: context,
                                  isUpdateTrue: true,
                                  playlistId: playlistId,
                                  playlistData: ReqPlaylistModel(
                                    name: playlistTitle?.name ?? "",
                                    imageURL: playlistTitle?.imageURL,
                                  ),
                                );
                              }
                              if (value == 2) {
                                showDailogForDeletePlaylist(context);
                              }
                            },
                          )
                        ],
                        title: ThemeText(
                          text: playlistTitle?.name ?? '',
                          lightTextColor: whiteColor,
                          fontSize: fontSize18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      itemCount: (playlistData.playlistArticles ?? []).length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => PrimaryListTileWidget(
                          imageUrl:
                              playlistData.playlistArticles?[index].imageURL,
                          title: playlistData.playlistArticles?[index].title,
                          isArticle: true,
                          subTitle:
                              playlistData.playlistArticles?[index].user?.name,
                          endIcon: PopupMenuButton<int>(
                            icon: SvgPicture.asset(
                              icMore,
                              height: 20,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: PopupTextButton(
                                  text: Localization.of().remove,
                                ),
                              ),
                            ],
                            offset: const Offset(0, 0),
                            color: secondaryColor,
                            elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                _removeFromPlaylist(playlistId,
                                    playlistData.playlistArticles?[index].id);
                              }
                            },
                          ),
                          onListTileClick: () {
                            Provider.of<PlayerProvider>(context, listen: false)
                                .setPlaylist(
                                    playlistData.playlistArticles ?? [], index);
                            locator<NavigationUtils>().push(routeAudioPlayer);
                          }),
                    ).titleScaffold(
                      context: context,
                      isTopRequired: false,
                      appBar: AppBar(
                        centerTitle: true,
                        actions: [
                          PopupMenuButton<int>(
                            icon: SvgPicture.asset(
                              icMore,
                              height: 20,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: PopupTextButton(
                                    text: Localization.of().edit),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: PopupTextButton(
                                    text: Localization.of().delete),
                              ),
                            ],
                            offset: const Offset(0, 0),
                            color: secondaryColor,
                            elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                getPlaylistActions(
                                  context: context,
                                  isUpdateTrue: true,
                                  playlistId: playlistId,
                                  playlistData: ReqPlaylistModel(
                                    name: playlistTitle?.name ?? "",
                                    imageURL: playlistTitle?.imageURL,
                                  ),
                                );
                              }
                              if (value == 2) {
                                showDailogForDeletePlaylist(context);
                              }
                            },
                          )
                        ],
                        title: ThemeText(
                          text: playlistTitle?.name ?? '',
                          lightTextColor: whiteColor,
                          fontSize: fontSize18,
                        ),
                      ),
                    );
        },
      );

  Scaffold _getCategoryData() => Consumer<PlaylistProvider>(
        builder: (context, playlistProvider, child) {
          var playlistData = playlistProvider.categoryArticles;
          return playlistProvider.isApiCalled == false
              ? const VerticalSkeletonView(
                  height: 100,
                  hPadding: 16,
                )
              : (playlistData ?? []).isEmpty && !(isApiCalled ?? false)
                  ? getEmptyTextWidget(
                      text: Localization.of().noArticleCategory)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      itemCount: (playlistData ?? []).length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => PrimaryListTileWidget(
                          title: playlistData?[index].title,
                          imageUrl: playlistData?[index].imageURL,
                          subTitle: playlistData?[index].user?.name,
                          isArticle: true,
                          endIcon: PopupMenuButton<int>(
                            icon: SvgPicture.asset(
                              icMore,
                              height: 20,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: PopupTextButton(
                                    text: Localization.of().addToPlaylist),
                              ),
                            ],
                            offset: const Offset(0, 0),
                            color: secondaryColor,
                            elevation: 2,
                            onSelected: (value) {
                              if (value == 1) {
                                addPlaylist(
                                  context: context,
                                  articleId: playlistData?[index].id ?? 0,
                                );
                              }
                            },
                          ),
                          onListTileClick: () {
                            Provider.of<PlayerProvider>(context, listen: false)
                                .setPlaylist(playlistData ?? [], index);
                            locator<NavigationUtils>().push(routeAudioPlayer);
                          }),
                    );
        },
      ).titleScaffold(
        context: context,
        isTopRequired: false,
        appBar: AppBar(
          centerTitle: true,
          actions: const [
            SizedBox(),
          ],
          title: ThemeText(
            text: widget.playlistData?.name ?? '',
            lightTextColor: whiteColor,
            fontSize: fontSize18,
          ),
        ),
      );

  showDailogForDeletePlaylist(BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          return Platform.isIOS
              ? CupertinoErrorDialog(
                  isCancelEnable: true,
                  okFunction: () => locator<NavigationUtils>().pop(),
                  message: Localization.of().playListDeleteText,
                )
              : MaterialErrorDialog(
                  isCancelEnable: true,
                  okFunction: () => locator<NavigationUtils>().pop(),
                  message: Localization.of().playListDeleteText,
                );
        });
  }
}

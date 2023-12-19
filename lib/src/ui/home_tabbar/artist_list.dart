import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/search_provider.dart';
import 'package:spotify_clone/src/widgets/incrementally_loading_listview.dart';
import 'package:spotify_clone/src/widgets/primary_list_tile_widget.dart';
import 'package:spotify_clone/src/widgets/transform_widget.dart';
import 'package:spotify_clone/src/widgets/vertical_skeleton_view.dart';

class ArtistList extends StatefulWidget {
  final bool fromSearch;
  const ArtistList({Key? key, this.fromSearch = false}) : super(key: key);

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshData() async {
    _refreshKey.currentState?.show();
    Provider.of<ArticlesProvider>(context, listen: false).artistClearPage();
    await getArtistApi(1);
  }

  getArtistApi(int page) {
    locator<HomeController>().getArtistApi(context: context, page: page);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return widget.fromSearch
        ? Consumer<SearchProvider>(
            builder: (context, searchArtists, child) {
              return (searchArtists.artistList ?? []).isEmpty
                  ? getEmptyTextWidget(text: Localization.of().dataNotFound)
                  : searchArtists.isApiCalled == false
                      ? const VerticalSkeletonView(
                          height: 100,
                          hPadding: 16,
                        )
                      : _getSearchArtists(searchArtists.artistList);
            },
          )
        : Consumer<ArticlesProvider>(
            builder: (context, artists, child) {
              return artists.isApiCalled == false
                  ? const VerticalSkeletonView(
                      height: 100,
                      hPadding: 16,
                    )
                  : _getArtists(artists);
            },
          );
  }

  Widget _getArtists(ArticlesProvider artistProvider) => RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        color: primaryColor,
        backgroundColor: Colors.transparent,
        child: IncrementallyLoadingListView(
          loadMore: () => getArtistApi(artistProvider.artistPage),
          hasMore: () => artistProvider.artistHasMoreItems,
          padding: const EdgeInsets.only(bottom: 50.0),
          itemCount: () => artistProvider.artistCount,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == (artistProvider.artistList).length - 1
                  ? const EdgeInsets.only(bottom: 30.0)
                  : index == 0
                      ? const EdgeInsets.only(top: 18.0)
                      : EdgeInsets.zero,
              child: PrimaryListTileWidget(
                isArticle: false,
                imageUrl: artistProvider.artistList[index].imageURL?.trim(),
                endIcon: TransformWidget(
                  child: SvgPicture.asset(
                    icRightArrow,
                    height: 20,
                  ),
                ),
                title: artistProvider.artistList[index].name,
                onListTileClick: () => locator<NavigationUtils>().push(
                  routeArtistProfile,
                  arguments: {
                    paramArtistId: artistProvider.artistList[index].id,
                    paramisFollowed:
                        artistProvider.artistList[index].isFollowed,
                  },
                ),
              ),
            );
          },
        ),
      );

  Widget _getSearchArtists(List<CategoryModel>? artistList) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 50.0),
        itemCount: (artistList ?? []).length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == (artistList ?? []).length - 1
                ? const EdgeInsets.only(bottom: 30.0)
                : index == 0
                    ? const EdgeInsets.only(top: 18.0)
                    : EdgeInsets.zero,
            child: PrimaryListTileWidget(
              isArticle: false,
              imageUrl: artistList?[index].imageURL?.trim(),
              endIcon: TransformWidget(
                child: SvgPicture.asset(
                  icRightArrow,
                  height: 20,
                ),
              ),
              title: artistList?[index].name,
              onListTileClick: () => locator<NavigationUtils>().push(
                routeArtistProfile,
                arguments: {
                  paramArtistId: artistList?[index].id,
                  paramisFollowed: artistList?[index].isFollowed,
                },
              ),
            ),
          );
        },
      );
}

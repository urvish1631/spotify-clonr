import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/providers/search_provider.dart';
import 'package:spotify_clone/src/widgets/incrementally_loading_listview.dart';
import 'package:spotify_clone/src/widgets/popmenu_widget.dart';
import 'package:spotify_clone/src/widgets/primary_list_tile_widget.dart';
import 'package:spotify_clone/src/widgets/vertical_skeleton_view.dart';

class ArticleList extends StatefulWidget {
  final bool fromSearch;
  const ArticleList({Key? key, this.fromSearch = false}) : super(key: key);

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshData() async {
    _refreshKey.currentState?.show();
    Provider.of<ArticlesProvider>(context, listen: false).articleClearPage();
    await getArticles(1);
  }

  getArticles(int page) {
    locator<HomeController>().getArticlesApi(context: context, page: page);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return widget.fromSearch
        ? Consumer<SearchProvider>(
            builder: (context, searchArticle, child) {
              return (searchArticle.articleList ?? []).isEmpty
                  ? getEmptyTextWidget(text: Localization.of().dataNotFound)
                  : searchArticle.isApiCalled == false
                      ? const VerticalSkeletonView(
                          height: 100,
                          hPadding: 16,
                        )
                      : _getSearchArticleList(searchArticle.articleList ?? []);
            },
          )
        : Consumer<ArticlesProvider>(
            builder: (context, articles, child) {
              return articles.isApiCalled == false
                  ? const VerticalSkeletonView(
                      height: 100,
                      hPadding: 16,
                    )
                  : _getArticleList(articles);
            },
          );
  }

  Widget _getArticleList(ArticlesProvider articleProvider) => RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        color: primaryColor,
        backgroundColor: Colors.transparent,
        child: IncrementallyLoadingListView(
          loadMore: () => getArticles(articleProvider.articlePage),
          hasMore: () => articleProvider.articleHasMoreItems,
          itemCount: () => articleProvider.articlesCount,
          padding: const EdgeInsets.only(bottom: 50.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == ((articleProvider.articleList ?? []).length - 1)
                  ? const EdgeInsets.only(bottom: 30.0)
                  : index == 0
                      ? const EdgeInsets.only(top: 18.0)
                      : EdgeInsets.zero,
              child: PrimaryListTileWidget(
                isArticle: true,
                imageUrl: articleProvider.articleList?[index].imageURL?.trim(),
                title: articleProvider.articleList?[index].title,
                subTitle: articleProvider.articleList?[index].user?.name,
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
                        articleId: articleProvider.articleList?[index].id ?? 0,
                      );
                    }
                  },
                ),
                onListTileClick: () {
                  Provider.of<PlayerProvider>(context, listen: false)
                      .setPlaylist(articleProvider.articleList ?? [], index);
                  locator<NavigationUtils>().push(routeAudioPlayer);
                },
              ),
            );
          },
        ),
      );

  Widget _getSearchArticleList(List<Article> articleList) {
    return ListView.builder(
      itemCount: articleList.length,
      padding: const EdgeInsets.only(bottom: 50.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == articleList.length - 1
              ? const EdgeInsets.only(bottom: 30.0)
              : index == 0
                  ? const EdgeInsets.only(top: 18.0)
                  : EdgeInsets.zero,
          child: PrimaryListTileWidget(
            isArticle: true,
            imageUrl: articleList[index].imageURL?.trim(),
            title: articleList[index].title,
            subTitle: articleList[index].user?.name,
            endIcon: PopupMenuButton<int>(
              icon: SvgPicture.asset(
                icMore,
                height: 20,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: PopupTextButton(text: Localization.of().addToPlaylist),
                ),
              ],
              offset: const Offset(0, 0),
              color: secondaryColor,
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  addPlaylist(
                    context: context,
                    articleId: articleList[index].id ?? 0,
                  );
                }
              },
            ),
            onListTileClick: () {
              Provider.of<PlayerProvider>(context, listen: false)
                  .setPlaylist(articleList, index);
              locator<NavigationUtils>().push(routeAudioPlayer);
            },
          ),
        );
      },
    );
  }
}

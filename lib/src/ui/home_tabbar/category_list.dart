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

class CategoryList extends StatefulWidget {
  final bool fromSearch;
  const CategoryList({Key? key, this.fromSearch = false}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshData() async {
    _refreshKey.currentState?.show();
    Provider.of<ArticlesProvider>(context, listen: false).categoryClearPage();
    await getCategoriesApi(1);
  }

  getCategoriesApi(int page) {
    locator<HomeController>().getCategoriesApi(context: context, page: page);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return widget.fromSearch
        ? Consumer<SearchProvider>(
            builder: (context, searchArticle, child) {
              return (searchArticle.categoryList ?? []).isEmpty
                  ? getEmptyTextWidget(text: Localization.of().dataNotFound)
                  : searchArticle.isApiCalled == false
                      ? const VerticalSkeletonView(
                          height: 100,
                          hPadding: 16,
                        )
                      : _getSearchListOfCategory(searchArticle.categoryList);
            },
          )
        : Consumer<ArticlesProvider>(
            builder: (context, articles, child) {
              return articles.isApiCalled == false
                  ? const VerticalSkeletonView(
                      height: 100,
                      hPadding: 16,
                    )
                  : _getListOfCategory(articles);
            },
          );
  }

  Widget _getListOfCategory(ArticlesProvider categoryProvider) =>
      RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        color: primaryColor,
        backgroundColor: Colors.transparent,
        child: IncrementallyLoadingListView(
          hasMore: () => categoryProvider.categoryHasMoreItems,
          loadMore: () => getCategoriesApi(categoryProvider.categoryPage),
          padding: const EdgeInsets.only(bottom: 50.0),
          itemCount: () => categoryProvider.categoriesCount,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == (categoryProvider.categoryList ?? []).length - 1
                  ? const EdgeInsets.only(bottom: 30.0)
                  : index == 0
                      ? const EdgeInsets.only(top: 18.0)
                      : EdgeInsets.zero,
              child: PrimaryListTileWidget(
                isArticle: false,
                isCategory: true,
                imageUrl:
                    categoryProvider.categoryList?[index].imageURL?.trim(),
                endIcon: TransformWidget(
                  child: SvgPicture.asset(
                    icRightArrow,
                    height: 20,
                  ),
                ),
                title: categoryProvider.categoryList?[index].name,
                onListTileClick: () => locator<NavigationUtils>().push(
                  routeDisplayPlaylist,
                  arguments: {
                    paramPlaylistData: categoryProvider.categoryList?[index],
                    paramFromPlayList: false,
                  },
                ),
              ),
            );
          },
        ),
      );

  Widget _getSearchListOfCategory(List<CategoryModel>? categoryList) =>
      ListView.builder(
        padding: const EdgeInsets.only(bottom: 50.0),
        itemCount: (categoryList ?? []).length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == (categoryList ?? []).length - 1
                ? const EdgeInsets.only(bottom: 30.0)
                : index == 0
                    ? const EdgeInsets.only(top: 18.0)
                    : EdgeInsets.zero,
            child: PrimaryListTileWidget(
              isArticle: false,
              isCategory: true,
              imageUrl: categoryList?[index].imageURL?.trim(),
              endIcon: TransformWidget(
                child: SvgPicture.asset(
                  icRightArrow,
                  height: 20,
                ),
              ),
              title: categoryList?[index].name,
              onListTileClick: () => locator<NavigationUtils>().push(
                routeDisplayPlaylist,
                arguments: {
                  paramPlaylistData: categoryList?[index],
                  paramFromPlayList: false,
                },
              ),
            ),
          );
        },
      );
}

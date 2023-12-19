import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/articles/req_recommendation_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/widgets/horizontal_skeleton_view.dart';
import 'package:spotify_clone/src/widgets/incrementally_loading_listview.dart';
import 'package:spotify_clone/src/widgets/primary_podcast_widget.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

import '../home_tabbar/home_tabbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isApiCalled = false;

  //Lifecycle methods
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isApiCalled) {
        getRecommendationsArticles(1);
        getCategories();
        getArtists();
        getArticles();
      }
    });
    super.initState();
  }

  // API calling functions
  getCategories() {
    locator<HomeController>().getCategoriesApi(context: context, page: 1);
  }

  getArtists() {
    locator<HomeController>().getArtistApi(context: context, page: 1);
  }

  getArticles() {
    locator<HomeController>().getArticlesApi(context: context, page: 1);
  }

  //Incrementing API call
  getRecommendationsArticles(int page) {
    if (page > 1) {
      final ids =
          Provider.of<ArticlesProvider>(context, listen: false).articleIds;
      locator<HomeController>().getRecommendationsApi(
          context: context,
          page: page,
          model: ReqRecommendationModel(previousArticles: ids));
    } else {
      setState(() {
        isApiCalled = true;
      });
      locator<HomeController>().getRecommendationsApi(
          context: context,
          page: page,
          model: ReqRecommendationModel(previousArticles: []));
    }
  }

  Future<void> _refreshData() async {
    _refreshKey.currentState?.show();
    Provider.of<ArticlesProvider>(context, listen: false).clearPage();
    await getRecommendationsArticles(1);
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _getRecommendedWidget(),
      const SizedBox(height: 10.0),
      const Expanded(child: HomeTabBar(fromSearch: false)),
    ]).homeScreenScaffold(
      context: context,
    );
  }

  //Widgets
  Widget _getRecommendedWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ThemeText(
              text: Localization.of().recommended,
              lightTextColor: whiteColor,
              fontSize: fontSize18,
              fontWeight: fontWeightSemiBold,
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 200,
              child: Consumer<ArticlesProvider>(
                builder: (context, recommendations, child) {
                  return recommendations.isApiCalled == false
                      ? const HorizontalSkeletonView(
                          height: 150,
                        )
                      : RefreshIndicator(
                          key: _refreshKey,
                          color: primaryColor,
                          backgroundColor: Colors.transparent,
                          onRefresh: () => _refreshData(),
                          child: IncrementallyLoadingListView(
                            hasMore: () => recommendations.hasMoreItems,
                            loadMore: () async {
                              await getRecommendationsArticles(
                                  recommendations.page);
                            },
                            itemCount: () =>
                                recommendations.recommendationsCount,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  Provider.of<PlayerProvider>(context,
                                          listen: false)
                                      .setPlaylist(
                                          recommendations.recommendedArticles ??
                                              [],
                                          index);
                                  locator<NavigationUtils>()
                                      .push(routeAudioPlayer);
                                },
                                child: DisplayPodcastWidget(
                                  image: recommendations
                                      .recommendedArticles?[index].imageURL
                                      ?.trim(),
                                  title: recommendations
                                      .recommendedArticles?[index].title,
                                  subTitle: recommendations
                                      .recommendedArticles?[index].user?.name,
                                  imageHeight: 130,
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/ui/home_tabbar/artist_list.dart';
import 'package:spotify_clone/src/ui/home_tabbar/category_list.dart';
import 'package:spotify_clone/src/ui/home_tabbar/article_list.dart';

class HomeTabBar extends StatefulWidget {
  final bool fromSearch;
  const HomeTabBar({Key? key, this.fromSearch = false}) : super(key: key);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  //Variables
  int? _selectedIndex;
  TabController? _tabController;

  //Life cycle methods
  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex ?? 0,
    );
    _tabController?.addListener(() {
      setState(() {
        _selectedIndex = _tabController?.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getTabs(_tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ArtistList(fromSearch: widget.fromSearch),
              ArticleList(fromSearch: widget.fromSearch),
              CategoryList(fromSearch: widget.fromSearch),
            ],
          ),
        ),
      ],
    );
  }

  //Widget
  Widget _getTabs(TabController? tabController) {
    return TabBar(
      labelColor: whiteColor,
      unselectedLabelColor: ternartColor,
      indicatorColor: primaryColor,
      controller: tabController,
      tabs: [
        Tab(
          text: Localization.of().artists,
        ),
        Tab(
          text: Localization.of().articles,
        ),
        Tab(
          text: Localization.of().category,
        ),
      ],
    );
  }
}

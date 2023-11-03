import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/context_extension.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/controllers/home/home_controller.dart';
import 'package:sada_app/src/providers/player_provider.dart';
import 'package:sada_app/src/providers/profile_data.provider.dart';
import 'package:sada_app/src/widgets/popmenu_widget.dart';
import 'package:sada_app/src/widgets/primary_list_tile_widget.dart';
import 'package:sada_app/src/widgets/profile_skeleton_view.dart';
import 'package:sada_app/src/widgets/shimmer_widget.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class ArtistProfileScreen extends StatefulWidget {
  final int? artistId;
  final int? isFollowed;
  const ArtistProfileScreen({
    Key? key,
    this.artistId,
    this.isFollowed,
  }) : super(key: key);

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  // Variables
  final _scrollController = ScrollController();
  final _borderRadius = ValueNotifier<double>(50.0);
  bool? isFollowing;
  bool? isScrolled;
  int? artistId;

  //API functions
  getArtistProfile() async {
    Provider.of<ProfileDataProvider>(context, listen: false).setApiFalse();
    await locator<AuthController>().getCreatorProfile(
      context: context,
      id: artistId ?? 0,
    );
  }

  followCreator() async {
    await locator<HomeController>().followTheCreatorApi(
      context: context,
      artistId: artistId ?? 0,
    );
    Provider.of<ProfileDataProvider>(context, listen: false)
        .followedArtist(isFollowing ?? false);
    setState(() {
      isFollowing = !(isFollowing ?? false);
    });
  }

  // Lifecycle Methods
  @override
  void initState() {
    isFollowing = widget.isFollowed != 0 ? true : false;
    artistId = widget.artistId;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getArtistProfile();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  //Scroll listener function
  void _scrollListener() {
    _borderRadius.value = _scrollController.offset > 307 ? 0.0 : 50.0;
    isScrolled = _scrollController.offset > 307 ? true : false;
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDataProvider>(
        builder: (context, profileDataProvider, child) {
      return profileDataProvider.isApiCalled == false
          ? const ProfileSkeletonView()
          : ValueListenableBuilder(
              valueListenable: _borderRadius,
              builder: (context, value, child) => CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _getAppBar(profileDataProvider),
                  _getTitles(Localization.of().articles, true),
                  (profileDataProvider.artistProfileData?.creatorProfile
                                  ?.articles ??
                              [])
                          .isEmpty
                      ? _getTitles(Localization.of().noArtistArticle, false)
                      : _getArticles(profileDataProvider),
                ],
              ),
            );
    }).normalScaffold(
      context: context,
      isTopRequired: true,
    );
  }

  //Widgets
  SliverAppBar _getAppBar(ProfileDataProvider profileData) => SliverAppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_borderRadius.value),
          bottomRight: Radius.circular(_borderRadius.value),
        )),
        pinned: true,
        centerTitle: true,
        title: isScrolled ?? false
            ? ThemeText(
                text: profileData
                        .artistProfileData?.creatorProfile?.creator?.name ??
                    '',
                lightTextColor: whiteColor,
                fontSize: fontSize16,
              )
            : null,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => locator<NavigationUtils>().pop(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => followCreator(),
                  child: isFollowing ?? false
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: whiteColor,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            children: [
                              ThemeText(
                                  text: Localization.of().following,
                                  lightTextColor: whiteColor,
                                  fontSize: fontSize14),
                              const Icon(
                                Icons.check,
                                size: 15.0,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: whiteColor),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: ThemeText(
                            text: Localization.of().follow,
                            lightTextColor: whiteColor,
                            fontSize: fontSize14,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
        floating: false,
        expandedHeight: 360.0,
        flexibleSpace: FlexibleSpaceBar(
          background: _getProfile(profileData),
        ),
      );

  SliverList _getArticles(ProfileDataProvider profileDataProvider) =>
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return PrimaryListTileWidget(
                isArticle: true,
                imageUrl: profileDataProvider.artistProfileData?.creatorProfile
                    ?.articles?[index].imageURL,
                endIcon: PopupMenuButton<int>(
                  icon: SvgPicture.asset(
                    icMore,
                    height: 20,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: PopupTextButton(
                        text: Localization.of().addToPlaylist,
                      ),
                    ),
                  ],
                  offset: const Offset(0, 0),
                  color: secondaryColor,
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      addPlaylist(
                          context: context,
                          articleId: profileDataProvider.artistProfileData
                                  ?.creatorProfile?.articles?[index].id ??
                              0);
                    }
                  },
                ),
                title: profileDataProvider
                    .artistProfileData?.creatorProfile?.articles?[index].title,
                onListTileClick: () {
                  Provider.of<PlayerProvider>(context, listen: false)
                      .setPlaylist(
                          profileDataProvider.artistProfileData?.creatorProfile
                                  ?.articles ??
                              [],
                          index);
                  locator<NavigationUtils>().push(routeAudioPlayer);
                });
          },
          childCount: profileDataProvider
              .artistProfileData?.creatorProfile?.articles?.length,
        ),
      );

  SliverToBoxAdapter _getTitles(String title, bool fontWeight) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: ThemeText(
            text: title,
            lightTextColor: whiteColor,
            fontSize: fontSize22,
            fontWeight: fontWeight ? fontWeightBold : fontWeightRegular,
            textAlign: fontWeight ? TextAlign.start : TextAlign.center,
          ),
        ),
      );

  Widget _getProfile(ProfileDataProvider profileData) {
    return SizedBox(
      width: context.getWidth(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getProfileDetails(profileData),
          _getProfileData(profileData),
        ],
      ),
    );
  }

  Widget _getProfileData(ProfileDataProvider profileData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              ThemeText(
                text: Localization.of().followers,
                lightTextColor: whiteColor,
                fontSize: fontSize14,
              ),
              ThemeText(
                text: profileData
                        .artistProfileData?.creatorProfile?.followerCount
                        .toString() ??
                    '',
                lightTextColor: whiteColor,
                fontSize: fontSize18,
                fontWeight: fontWeightBold,
              ),
            ],
          ),
          Column(
            children: [
              ThemeText(
                text: Localization.of().articles,
                lightTextColor: whiteColor,
                fontSize: fontSize14,
              ),
              ThemeText(
                text: profileData
                        .artistProfileData?.creatorProfile?.articleCount
                        .toString() ??
                    '',
                lightTextColor: whiteColor,
                fontSize: fontSize18,
                fontWeight: fontWeightBold,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getProfileDetails(ProfileDataProvider profileData) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: whiteColor.withOpacity(0.3),
          spreadRadius: 30,
          blurRadius: 50,
          offset: const Offset(0, -4),
        ),
      ]),
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            width: context.getWidth(),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: (profileData.artistProfileData?.creatorProfile?.creator
                              ?.imageURL ??
                          '')
                      .isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileData.artistProfileData?.creatorProfile
                              ?.creator?.imageURL
                              ?.trim() ??
                          '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(),
                      placeholder: (context, url) => ShimmerWidget(
                        height: context.getHeight(0.2),
                        width: context.getWidth(),
                      ),
                    )
                  : Image.asset(
                      dummyArtistProfileImage,
                      fit: BoxFit.cover,
                      color: const Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate,
                      width: context.getWidth(),
                    ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            child: ThemeText(
              text: profileData
                      .artistProfileData?.creatorProfile?.creator?.name ??
                  "",
              lightTextColor: whiteColor,
              fontSize: fontSize24,
              fontWeight: fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}

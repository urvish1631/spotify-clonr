import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/dialog_utils.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/controllers/article/article_controller.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/providers/profile_data.provider.dart';
import 'package:spotify_clone/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:spotify_clone/src/widgets/customdialogs/material_error_dialog.dart';
import 'package:spotify_clone/src/widgets/popmenu_widget.dart';
import 'package:spotify_clone/src/widgets/primary_list_tile_widget.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/profile_skeleton_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variables
  final _scrollController = ScrollController();
  final _borderRadius = ValueNotifier<double>(50.0);

  // Lifecycle Methods
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (getBool(prefkeyIsCreator)) {
        _getCreatorProfileAPICall();
      } else {
        _getUserProfileAPICall();
      }
    });
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
  }

  // Build method
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _borderRadius,
      builder: (context, value, child) =>
          Consumer<ProfileDataProvider>(builder: (context, profileData, child) {
        return profileData.isApiCalled == false
            ? const ProfileSkeletonView()
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _appBar(profileData),
                  _myArticlesTitle(),
                  getBool(prefkeyIsCreator) &&
                          (profileData.creatorData?.creatorProfile?.articles ??
                                  [])
                              .isEmpty
                      ? SliverToBoxAdapter(
                          child: getEmptyTextWidget(
                              text: Localization.of().noCreatedArticles),
                        )
                      : getBool(prefkeyIsCreator)
                          ? _listOfArticles(profileData)
                          : _settingsSection()
                ],
              ).normalScaffold(
                context: context,
                isTopRequired: false,
              );
      }),
    );
  }

  //Widgets
  SliverAppBar _appBar(ProfileDataProvider profileData) => SliverAppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(_borderRadius.value),
          bottomRight: Radius.circular(_borderRadius.value),
        )),
        backgroundColor: secondaryColor,
        pinned: true,
        leading: const SizedBox(),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(Localization.of().profile,
              style: const TextStyle(
                color: whiteColor,
              )),
        ),
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              String imageUrl = getBool(prefkeyIsCreator)
                  ? profileData
                          .creatorData?.creatorProfile?.creator?.imageURL ??
                      ''
                  : profileData.userProfileData?.userProfile?.user?.imageURL ??
                      "";
              locator<NavigationUtils>().push(
                routeEditProfile,
                arguments: {
                  paramImageUrl: imageUrl,
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: Icon(
                Icons.edit_rounded,
                size: 30.0,
              ),
            ),
          ),
        ],
        floating: false,
        expandedHeight: 360.0,
        flexibleSpace: FlexibleSpaceBar(
          background: _getProfile(profileData),
        ),
      );

  SliverToBoxAdapter _myArticlesTitle() => getBool(prefkeyIsCreator)
      ? SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: ThemeText(
              text: Localization.of().myArticles,
              lightTextColor: whiteColor,
              fontSize: fontSize22,
              fontWeight: fontWeightBold,
            ),
          ),
        )
      : const SliverToBoxAdapter();

  SliverToBoxAdapter _settingsSection() => SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _getListTile(Icons.language, Localization.of().language,
                () => locator<NavigationUtils>().push(routeLanguageScreen)),
            _getListTile(
              Icons.privacy_tip_outlined,
              Localization.of().privacyPolicy,
              () => locator<NavigationUtils>()
                  .push(routeTermsAndCondition, arguments: {
                paramFromTerms: false,
              }),
            ),
            _getListTile(Icons.assignment, Localization.of().termsCondition,
                () {
              locator<NavigationUtils>()
                  .push(routeTermsAndCondition, arguments: {
                paramFromTerms: true,
              });
            }),
            _getListTile(
              Icons.delete_outline_rounded,
              Localization.of().deleteAccount,
              () => showAlertDialog(
                message: Localization.of().msgDeleteAccount,
                okButtonAction: () {
                  locator<AuthController>()
                      .deleteProfileApiCall(context: context);
                },
              ),
            ),
            _getListTile(Icons.logout_rounded, Localization.of().logout,
                () => showDialogForLogout(context)),
          ],
        ),
      );

  SliverList _listOfArticles(ProfileDataProvider profileData) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: index ==
                      (profileData.creatorData?.creatorProfile?.articles ?? [])
                              .length -
                          1
                  ? const EdgeInsets.only(
                      bottom: 50.0, top: 8.0, right: 8.0, left: 8.0)
                  : const EdgeInsets.all(8.0),
              child: PrimaryListTileWidget(
                  isArticle: true,
                  imageUrl: profileData
                      .creatorData?.creatorProfile?.articles?[index].imageURL,
                  title: profileData
                      .creatorData?.creatorProfile?.articles?[index].title,
                  subTitle: getString(prefkeyUserName),
                  endIcon: PopupMenuButton<int>(
                    icon: SvgPicture.asset(
                      icMore,
                      height: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: PopupTextButton(text: Localization.of().edit),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: PopupTextButton(text: Localization.of().delete),
                      )
                    ],
                    offset: const Offset(0, 0),
                    color: secondaryColor,
                    elevation: 2,
                    onSelected: (value) {
                      if (value == 1) {
                        if ((profileData.creatorData?.creatorProfile
                                        ?.articles?[index].writtenText ??
                                    '')
                                .isNotEmpty &&
                            (profileData.creatorData?.creatorProfile
                                        ?.articles?[index].articleType ??
                                    '') ==
                                writtenArticle) {
                          locator<NavigationUtils>()
                              .push(routeUpdateArticle, arguments: {
                            paramFromProfile: true,
                            paramArticleData: profileData
                                .creatorData?.creatorProfile?.articles?[index]
                          });
                        } else {
                          // showDialogForNotEditing(context);
                          locator<NavigationUtils>()
                              .push(routePublishArticle, arguments: {
                            paramRecordedFile: profileData.creatorData
                                ?.creatorProfile?.articles?[index].recordedFile,
                            paramFromProfile: true,
                            paramArticleData: profileData
                                .creatorData?.creatorProfile?.articles?[index],
                            paramArticleId: profileData.creatorData
                                ?.creatorProfile?.articles?[index].id
                          });
                        }
                      }
                      if (value == 2) {
                        int? articleId = profileData
                            .creatorData?.creatorProfile?.articles?[index].id;
                        showDialogForDeleteArticle(context, articleId ?? 0);
                      }
                    },
                  ),
                  onListTileClick: () {
                    var isWritten = profileData
                        .creatorData?.creatorProfile?.articles?[index];
                    if ((isWritten?.writtenText ?? '').isEmpty &&
                        isWritten?.articleType != writtenArticle) {
                      var list = profileData
                          .creatorData?.creatorProfile?.articles
                          ?.where((element) =>
                              element.articleType == recordedArticle)
                          .toList();
                      var finds = list?.firstWhere(
                          (element) => element.id == isWritten?.id);
                      int? jIndex = list?.indexOf(finds ?? Article());
                      Provider.of<PlayerProvider>(context, listen: false)
                          .setPlaylist(
                              profileData
                                      .creatorData?.creatorProfile?.articles ??
                                  [],
                              jIndex ?? 0);
                      locator<NavigationUtils>().push(routeAudioPlayer);
                    } else {
                      locator<NavigationUtils>()
                          .push(routeUpdateArticle, arguments: {
                        paramFromProfile: true,
                        paramArticleData: profileData
                            .creatorData?.creatorProfile?.articles?[index],
                        paramIsWrittenArticle: true,
                      });
                    }
                  }),
            );
          },
          childCount: profileData.creatorData?.creatorProfile?.articles?.length,
        ),
      );

  Widget _getProfile(ProfileDataProvider profileData) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: context.getWidth(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: context.getHeight(0.12)),
          _getProfileDetails(profileData),
          const SizedBox(height: 10.0),
          _getProfileData(profileData)
        ],
      ),
    );
  }

  Widget _getProfileData(ProfileDataProvider profileData) {
    return getBool(prefkeyIsCreator)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ThemeText(
                    text: Localization.of().followers,
                    lightTextColor: whiteColor,
                    fontSize: fontSize14,
                  ),
                  ThemeText(
                    text: profileData.creatorData?.creatorProfile?.followerCount
                            .toString() ??
                        '',
                    lightTextColor: whiteColor,
                    fontSize: fontSize18,
                    fontWeight: fontWeightBold,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ThemeText(
                    text: Localization.of().myArticles,
                    lightTextColor: whiteColor,
                    fontSize: fontSize14,
                  ),
                  ThemeText(
                    text: profileData.creatorData?.creatorProfile?.articleCount
                            .toString() ??
                        "",
                    lightTextColor: whiteColor,
                    fontSize: fontSize18,
                    fontWeight: fontWeightBold,
                  ),
                ],
              )
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ThemeText(
                text: Localization.of().following,
                lightTextColor: whiteColor,
                fontSize: fontSize14,
              ),
              ThemeText(
                text: profileData.userProfileData?.userProfile?.followingCount
                        .toString() ??
                    '',
                lightTextColor: whiteColor,
                fontSize: fontSize18,
                fontWeight: fontWeightBold,
              ),
            ],
          );
  }

  Widget _getProfileDetails(ProfileDataProvider profileData) {
    return Column(
      children: [
        (profileData.creatorData?.creatorProfile?.creator?.imageURL ?? '')
                    .isNotEmpty &&
                getBool(prefkeyIsCreator)
            ? ProfileImageView(
                imageUrl: profileData
                        .creatorData?.creatorProfile?.creator?.imageURL ??
                    '',
                size: 110,
              )
            : (profileData.userProfileData?.userProfile?.user?.imageURL ?? '')
                        .isNotEmpty &&
                    getBool(prefkeyIsUser)
                ? ProfileImageView(
                    imageUrl: profileData
                            .userProfileData?.userProfile?.user?.imageURL ??
                        '',
                    size: 110,
                  )
                : const ProfileImageView(imageUrl: dummyImage, size: 110),
        const SizedBox(height: 10),
        ThemeText(
          text: getBool(prefkeyIsCreator)
              ? profileData.creatorData?.creatorProfile?.creator?.name ?? ''
              : profileData.userProfileData?.userProfile?.user?.name ?? '',
          lightTextColor: whiteColor,
          fontSize: fontSize24,
          fontWeight: fontWeightSemiBold,
        ),
        const SizedBox(height: 5),
        ThemeText(
          text: getBool(prefkeyIsCreator)
              ? profileData.creatorData?.creatorProfile?.creator?.email ?? ''
              : profileData.userProfileData?.userProfile?.user?.email ?? '',
          lightTextColor: whiteColor,
          fontSize: fontSize18,
        ),
      ],
    );
  }

  Widget _getListTile(IconData icon, String title, void Function() onClick) =>
      InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onClick,
        child: ListTile(
          leading: Icon(
            icon,
            color: whiteColor,
            size: 30,
          ),
          title: Text(title),
        ),
      );

  showDialogForDeleteArticle(BuildContext ctx, int id) {
    return showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return Platform.isIOS
            ? CupertinoErrorDialog(
                isCancelEnable: true,
                okFunction: () => _deleteArticleApi(id),
                message: Localization.of().deleteArticle,
              )
            : MaterialErrorDialog(
                isCancelEnable: true,
                okFunction: () => _deleteArticleApi(id),
                message: Localization.of().deleteArticle,
              );
      },
    );
  }

  //API calling functions
  _getCreatorProfileAPICall() async {
    await locator<AuthController>().getCreatorProfile(
      context: context,
      id: getInt(prefkeyId),
    );
  }

  _getUserProfileAPICall() async {
    await locator<AuthController>().getUserProfile(context: context);
  }

  _deleteArticleApi(int id) async {
    await locator<ArticleController>()
        .deleteArticleApi(context: context, articleId: id);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/providers/bottom_tabbar_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/ui/home/playlist_screen.dart';
import 'package:spotify_clone/src/ui/home/recent_play.screen.dart';
import 'package:spotify_clone/src/ui/home/home_screen.dart';
import 'package:spotify_clone/src/ui/profile/profile_screen.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';
import 'package:spotify_clone/src/widgets/transform_widget.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  //Variables
  final List<Widget> _children = [
    const HomeScreen(),
    const PlayListScreen(),
    const RecentlyPlayedScreen(),
    const ProfileScreen(),
  ];

  //Build methods
  @override
  Widget build(BuildContext context) {
    return Consumer2<BottomTabBarProvider, PlayerProvider>(
        builder: (context, data, playerProvider, child) {
      var currentArticle = playerProvider.currentArticle;
      return Scaffold(
        floatingActionButton: getBool(prefkeyIsCreator)
            ? FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: () {
                  locator<NavigationUtils>().push(routeAudioRecorder);
                },
                child: CircleAvatar(
                  minRadius: 30.0,
                  backgroundColor: blackColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(icMic),
                  ),
                ),
              )
            : FloatingActionButton(
                backgroundColor: blackColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: () {},
                child: CircleAvatar(
                  backgroundColor: blackColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset(
                      iconLogo,
                    ),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _children[data.currentIndex],
        persistentFooterButtons:
            currentArticle == null ? null : _getMiniPlayer(playerProvider),
        bottomNavigationBar: BottomNavigationBar(
          mouseCursor: SystemMouseCursors.click,
          selectedItemColor: primaryColor,
          elevation: 10.0,
          backgroundColor: secondaryColor,
          currentIndex: data.currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          onTap: (index) {
            data.setIndex(index);
          },
          unselectedItemColor: whiteColor,
          selectedLabelStyle: const TextStyle(color: primaryColor),
          unselectedLabelStyle: const TextStyle(color: whiteColor),
          showUnselectedLabels: true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          items: [
            _getBottomNavigationBarItem(
                title: Localization.of().home,
                icon: icHome,
                isSelected: data.currentIndex == 0),
            _getBottomNavigationBarItem(
                title: Localization.of().playList,
                icon: icPlayList,
                isSelected: data.currentIndex == 1),
            _getBottomNavigationBarItem(
                title: Localization.of().recent,
                icon: icClock,
                isSelected: data.currentIndex == 2),
            _getBottomNavigationBarItem(
                title: Localization.of().profile,
                icon: icProfile,
                isSelected: data.currentIndex == 3),
          ],
        ),
      );
    });
  }

  //Widget
  BottomNavigationBarItem _getBottomNavigationBarItem(
      {required String icon, required String title, required bool isSelected}) {
    return BottomNavigationBarItem(
      label: title,
      tooltip: "",
      backgroundColor: primaryColor,
      icon: MouseRegion(
        opaque: true,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: icon.isNotEmpty
              ? SvgPicture.asset(
                  icon,
                  height: 25,
                  width: 25,
                  color: isSelected ? primaryColor : whiteColor,
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget getCurrentStatusButton(AudioPlayer audioPlayer) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          return !(playing ?? false) &&
                  (processingState == ProcessingState.loading)
              ? IconButton(
                  onPressed: () => {},
                  color: whiteColor,
                  icon: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: CircularProgressIndicator(
                      color: whiteColor,
                    ),
                  ),
                )
              : (playing ?? false) &&
                      (processingState != ProcessingState.completed)
                  ? IconButton(
                      onPressed: audioPlayer.pause,
                      color: whiteColor,
                      icon: const Icon(
                        Icons.pause,
                        size: 50,
                      ),
                    )
                  : IconButton(
                      onPressed: audioPlayer.play,
                      color: whiteColor,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 50,
                      ),
                    );
        });
  }

  List<Widget> _getMiniPlayer(PlayerProvider playerProvider) {
    return [
      GestureDetector(
        onTap: () {
          locator<NavigationUtils>().push(routeAudioPlayer);
        },
        child: Column(
          children: [
            StreamBuilder<SequenceState?>(
              stream: playerProvider.audioPlayer.sequenceStateStream,
              builder: (context, sequenceState) {
                final state = sequenceState.data;
                final data = state?.currentSource?.tag;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data?.artUri?.toString() == null ||
                            (data?.artUri?.toString() ?? '').isEmpty
                        ? const ProfileImageView(
                            imageUrl: dummyArticleImage,
                            size: 50,
                          )
                        : ProfileImageView(
                            imageUrl: data?.artUri?.toString().trim() ?? '',
                            size: 50,
                          ),
                    SizedBox(
                      width: context.getWidth(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ThemeText(
                            text: data?.title ?? '',
                            lightTextColor: whiteColor,
                            fontSize: fontSize16,
                            fontWeight: fontWeightBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          ThemeText(
                            text: data?.artist ?? '',
                            lightTextColor: whiteColor,
                            fontSize: fontSize12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await playerProvider.audioPlayer.seekToPrevious();
                          },
                          icon: TransformWidget(
                            child: SvgPicture.asset(
                              icPrevious,
                              width: 20,
                            ),
                          ),
                        ),
                        getCurrentStatusButton(playerProvider.audioPlayer),
                        IconButton(
                          onPressed: () async {
                            if (playerProvider
                                    .audioPlayer.playerState.processingState !=
                                ProcessingState.completed) {
                              await locator<HomeController>().recentPlayedTrack(
                                  context: context, id: int.parse(data?.id));
                            }
                            await playerProvider.audioPlayer.seekToNext();
                          },
                          icon: TransformWidget(
                            child: SvgPicture.asset(
                              icNext,
                              width: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await playerProvider.audioPlayer.stop();
                            playerProvider.clearArticle();
                          },
                          icon: Image.asset(
                            icCancel,
                            color: Colors.grey,
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ];
  }
}

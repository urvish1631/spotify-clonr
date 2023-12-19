import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/position_data_model.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/widgets/control_widget.dart';
import 'package:spotify_clone/src/widgets/media_state_widget.dart';
import 'package:spotify_clone/src/widgets/popmenu_widget.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';
import 'package:spotify_clone/src/widgets/transform_widget.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<double> audioSpeedRates = [0.25, 0.5, 0.75, 1, 1.5, 1.75, 2];
  final ValueNotifier<int> _currentRateIndex = ValueNotifier<int>(3);
  final ValueNotifier<String> _buttonText = ValueNotifier<String>('1.0x');
  int? articleId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<PlayerProvider>(builder: (context, audioPlayer, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<SequenceState?>(
                stream: audioPlayer.audioPlayer.sequenceStateStream,
                builder: (context, sequenceState) {
                  final state = sequenceState.data;
                  final data = state?.currentSource?.tag;
                  final index = state?.currentIndex;
                  if (audioPlayer.audioPlayer.playerState.processingState ==
                      ProcessingState.loading) {
                    locator<HomeController>().recentPlayedTrack(
                        context: context, id: int.parse(data?.id));
                  }
                  return MediaState(
                    index: index ?? 0,
                    id: data?.id ?? '',
                    title: data?.title ?? '',
                    artist: data?.artist ?? '',
                    imageUrl: data?.artUri?.toString().trim() ?? '',
                  );
                }),
            StreamBuilder<PositionData>(
              stream: audioPlayer.positionDataStream,
              builder: (context, snapshot) {
                final postiondata = snapshot.data;
                return Column(
                  children: [
                    _getAudioSlider(
                      postiondata?.duration,
                      postiondata?.position,
                      audioPlayer,
                    ),
                    _getPlayerActions(audioPlayer)
                  ],
                );
              },
            ),
          ],
        );
      }),
    ).playerScreen();
  }

  Widget _getPlayerActions(PlayerProvider audioPlayer) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: _buttonText,
              builder: (context, buttonText, child) {
                return ValueListenableBuilder<int>(
                  valueListenable: _currentRateIndex,
                  builder: (context, currentRateIndex, child) {
                    return PopupMenuButton<int>(
                      itemBuilder: (context) =>
                          List.generate(audioSpeedRates.length, (index) {
                        return PopupMenuItem(
                          value: index,
                          child: PopupTextButton(
                              text: '${audioSpeedRates[index]}'),
                        );
                      }),
                      offset: const Offset(0, 0),
                      color: secondaryColor,
                      elevation: 2,
                      onSelected: (value) {
                        _currentRateIndex.value = value;
                        audioPlayer.changeSpeedRate(audioSpeedRates[value]);
                        _buttonText.value = '${audioSpeedRates[value]}x';
                      },
                      child: SizedBox(
                        width: 40,
                        child: ThemeText(
                          text: buttonText,
                          lightTextColor: whiteColor,
                          fontSize: fontSize14,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            GestureDetector(
              onTap: () async {
                await audioPlayer.audioPlayer.seekToPrevious();
              },
              child: TransformWidget(
                child: SvgPicture.asset(
                  icPrevious,
                  width: 20,
                ),
              ),
            ),
            ControlWidget(audioPlayer: audioPlayer.audioPlayer),
            GestureDetector(
              onTap: () async {
                await audioPlayer.audioPlayer.seekToNext();
              },
              child: TransformWidget(
                child: SvgPicture.asset(
                  icNext,
                  width: 20,
                ),
              ),
            ),
            PopupMenuButton<int>(
              icon: SvgPicture.asset(
                icMore,
                height: 20,
                width: 20,
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
                      articleId: audioPlayer
                              .listOfArticle?[
                                  audioPlayer.audioPlayer.currentIndex ?? 0]
                              .id ??
                          0);
                }
              },
            ),
          ],
        ),
      );

  Widget _getAudioSlider(
      Duration? duration, Duration? position, PlayerProvider audioPlayer) {
    return Column(
      children: [
        Slider(
          min: 0,
          activeColor: primaryColor,
          max: duration?.inSeconds.toDouble() ?? 0.0,
          value: position?.inSeconds.toDouble() ?? 0.0,
          onChanged: (double value) async {
            final newPosition = Duration(seconds: value.toInt());
            await audioPlayer.audioPlayer.seek(newPosition);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(position ?? Duration.zero)),
              Text(formatTime(
                  (duration ?? Duration.zero) - (position ?? Duration.zero))),
            ],
          ),
        ),
      ],
    );
  }
}

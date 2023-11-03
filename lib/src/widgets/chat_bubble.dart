import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/context_extension.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/controllers/comments/comment_controller.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';
import 'package:sada_app/src/providers/player_provider.dart';
import 'package:sada_app/src/widgets/profile_image_view.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

typedef ValueChanged<T> = void Function(T value);

class CommentAudioPlayer extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;
  final User? user;
  final List<PlayerController>? controller;
  final Directory appDirectory;
  final bool? fromRecorder;
  final bool? recordingCompleted;
  final String? recordedFile;
  final int? commentId;
  final int articleId;
  final ValueChanged<int>? onFileDownload;

  const CommentAudioPlayer(
      {Key? key,
      required this.appDirectory,
      this.width,
      this.recordingCompleted,
      this.articleId = 0,
      this.index,
      this.commentId,
      this.user,
      this.controller,
      this.onFileDownload,
      this.isSender = false,
      this.recordedFile,
      this.path,
      this.fromRecorder = false})
      : super(key: key);

  @override
  State<CommentAudioPlayer> createState() => _CommentAudioPlayerState();
}

class _CommentAudioPlayerState extends State<CommentAudioPlayer> {
  File? file;
  bool? isPlayerPlaying;
  PlayerController controller = PlayerController();
  PlayerProvider playerProvider = PlayerProvider();

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  @override
  void initState() {
    controller = widget.controller?[widget.index ?? 0] ?? PlayerController();
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    super.initState();
    _preparePlayer();
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (widget.index != null) {
      final response = await http.get(Uri.parse(widget.recordedFile ?? ''));
      file = File('${widget.appDirectory.path}/audio${widget.index}.m4a');
      await file?.writeAsBytes(response.bodyBytes);
      (widget.onFileDownload ?? () {})(1);
    }
    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: widget.path ?? file!.path,
      shouldExtractWaveform: true,
    );

    // Extracting waveform separately if index is odd.
    if (widget.index != null) {
      controller
          .extractWaveformData(
            path: widget.path ?? file!.path,
            noOfSamples: playerWaveStyle.getSamplesForWidth(
              widget.width ?? 200,
            ),
          )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  deleteAPI(int id) {
    locator<CommentController>().deleteComment(
        context: context, commentId: id, articleId: widget.articleId);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Align(
              alignment: widget.fromRecorder ?? false
                  ? Alignment.center
                  : widget.isSender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: SizedBox(
                width: widget.fromRecorder ?? false
                    ? context.getWidth()
                    : context.getWidth(0.7),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    StreamBuilder<PlayerState>(
                        stream: controller.onPlayerStateChanged,
                        builder: (context, snapshot) {
                          return Container(
                            padding: const EdgeInsets.only(right: 5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.isSender
                                  ? primaryColor
                                  : secondaryColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (!(controller.playerState.isStopped) &&
                                    !(controller.playerState.isPlaying))
                                  IconButton(
                                    onPressed: () async {
                                      if (playerProvider.audioPlayer.playing) {
                                        playerProvider.audioPlayer.pause();
                                      }
                                      for (PlayerController element
                                          in widget.controller ?? []) {
                                        if (element.playerState.isPlaying) {
                                          await element.pausePlayer();
                                        }
                                      }
                                      await controller.startPlayer(
                                        finishMode: FinishMode.pause,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.play_arrow,
                                    ),
                                    color: whiteColor,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                if (controller.playerState.isPlaying)
                                  IconButton(
                                    onPressed: () async {
                                      if (controller.playerState.isPlaying) {
                                        await controller.pausePlayer();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.stop,
                                    ),
                                    color: whiteColor,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                AudioFileWaveforms(
                                  size: widget.fromRecorder ?? false
                                      ? Size(context.getWidth(0.7), 70)
                                      : Size(context.getWidth(0.4), 70),
                                  playerController: controller,
                                  waveformType: WaveformType.long,
                                  playerWaveStyle: playerWaveStyle,
                                ),
                                if (widget.isSender) const SizedBox(width: 10),
                                if (widget.isSender &&
                                    !(widget.fromRecorder ?? false))
                                  IconButton(
                                    onPressed: () {
                                      if (widget.commentId != 0) {
                                        deleteAPI(widget.commentId ?? 0);
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: whiteColor,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                              ],
                            ),
                          );
                        }),
                    widget.fromRecorder ?? false
                        ? const SizedBox()
                        : Positioned(
                            top: -20,
                            left: 60,
                            child: ThemeText(
                              text: widget.isSender
                                  ? getString(prefkeyUserName)
                                  : widget.user?.name ?? "",
                              lightTextColor: whiteColor,
                              fontSize: fontSize18,
                            ),
                          ),
                    widget.fromRecorder ?? false
                        ? const SizedBox()
                        : Positioned(
                            top: -40,
                            left: -10,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: blackColor,
                              child: ClipOval(
                                child: (widget.user?.imageURL ?? "").isEmpty
                                    ? const ProfileImageView(
                                        imageUrl: dummyImage,
                                        size: 70,
                                      )
                                    : ProfileImageView(
                                        imageUrl: (widget.user?.imageURL ?? "")
                                            .trim(),
                                        size: 70,
                                      ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/dic_params.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/models/articles/res_image_upload_model.dart';
import 'package:spotify_clone/src/widgets/chat_bubble.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({Key? key}) : super(key: key);

  @override
  State<AudioRecorderScreen> createState() => _AudioRecorderScreenState();
}

enum RecorderState { start, playing, stopped, completed }

class _AudioRecorderScreenState extends State<AudioRecorderScreen>
    with TickerProviderStateMixin {
  // Variables
  final _recorderState = ValueNotifier<RecorderState>(RecorderState.start);
  final _isRecordUploading = ValueNotifier<bool>(false);
  final _isAutomaticCompletedOnce = ValueNotifier<bool>(false);
  RecorderController recorderController = RecorderController();
  String? path;
  String? musicFile;
  int maxTimeLimit = 300;
  late Directory appDirectory;
  AnimationController? _animationController;
  PlayerController controller = PlayerController();
  bool isAccess = false;

  //Void functions
  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
  }

  _getRecorderPermission(context) async {
    isAccess = await recorderPermission(context: context);
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 50000;
    recorderController.bitRate = 128000;
  }

  void _startOrStopRecording({bool? isCompleted}) async {
    try {
      if (_recorderState.value == RecorderState.playing) {
        recorderController.reset();
        await recorderController.stop(false);
      } else {
        if (isCompleted != null && isCompleted) {
        } else {
          await recorderController.record(path: path ?? "");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _recorderState.value == RecorderState.stopped;
    }
  }

  //Life cycle methods
  @override
  void initState() {
    if (!isAccess) {
      _getRecorderPermission(context);
    }
    _getDir();
    _initialiseControllers();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController = AnimationController(vsync: this);
      _animationController?.addListener(() {
        if ((_animationController?.value)! > 0.5) {
          _animationController?.repeat();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ValueListenableBuilder(
          valueListenable: _recorderState,
          builder: (context, recordState, child) {
            return StreamBuilder<Duration>(
              stream: recorderController.onCurrentDuration,
              builder: (context, snapshot) {
                var timeRecorded = snapshot.data ?? Duration.zero;
                return ListView(
                  children: [
                    _recorderState.value == RecorderState.playing
                        ? AudioWaveforms(
                            enableGesture: true,
                            size: Size(context.getWidth(0.7), 50),
                            recorderController: recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: whiteColor,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF1E1B26),
                            ),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                          )
                        : _recorderState.value == RecorderState.stopped
                            ? CommentAudioPlayer(
                                controller: [controller],
                                fromRecorder: true,
                                path: path,
                                isSender: true,
                                appDirectory: appDirectory,
                              )
                            : Container(
                                height: 60,
                                width: context.getWidth(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xFF1E1B26),
                                ),
                              ),
                    _getRecordButton(timeRecorded),
                    const SizedBox(height: 20),
                    _getGetButtons(timeRecorded),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget _getRecordButton(Duration timeRecorded) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          recordAnimation,
          animate: _recorderState.value == RecorderState.playing,
          height: context.getHeight(0.4),
          width: context.getHeight(0.4),
          repeat: true,
          controller: _animationController,
          onLoaded: (composition) {
            _animationController?.duration = composition.duration;
          },
        ),
        _getRecordingTime(_recorderState.value == RecorderState.start
            ? Duration.zero
            : timeRecorded),
      ],
    );
  }

  Widget _getRecordingTime(Duration time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeText(
          text: formatTime(time),
          lightTextColor: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Column _getGetButtons(Duration timeRecorded) {
    if (timeRecorded.inSeconds == maxTimeLimit &&
        !_isAutomaticCompletedOnce.value) {
      _animationController?.reset();
      recorderController.stop();
      _startOrStopRecording(isCompleted: true);
      _recorderState.value = RecorderState.stopped;
      _isAutomaticCompletedOnce.value = true;
    } else {}
    return Column(
      children: [
        Row(
          mainAxisAlignment: _recorderState.value == RecorderState.stopped
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            _recorderState.value == RecorderState.stopped
                ? ValueListenableBuilder(
                    valueListenable: _isRecordUploading,
                    builder: (context, uploading, child) {
                      return CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 30,
                        child: IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.check, color: blackColor),
                          onPressed: uploading == false
                              ? () async {
                                  if (path != null) {
                                    _isRecordUploading.value = true;
                                    final formData = FormData.fromMap(
                                        {'mediaType': article});
                                    final recordedFile = MapEntry(
                                      'file',
                                      await MultipartFile.fromFile(
                                        path ?? '',
                                        contentType: getImageContentType(
                                            filePath: path ?? ''),
                                      ),
                                    );
                                    formData.files.add(recordedFile);
                                    final ResImageUploadModel response =
                                        await _uploadRecord(formData);
                                    if ((response.data ?? '').isNotEmpty) {
                                      if (controller.playerState.isPlaying) {
                                        await controller.pausePlayer();
                                      }
                                      await locator<NavigationUtils>().push(
                                        routePublishArticle,
                                        arguments: {
                                          paramRecordedFile: response.data,
                                          paramArticleRecorded: true,
                                        },
                                      );
                                    }
                                  }
                                }
                              : () {},
                        ),
                      );
                    })
                : CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 30,
                    child: IconButton(
                      onPressed: () async {
                        switch (_recorderState.value) {
                          case RecorderState.playing:
                            _animationController?.reset();
                            _startOrStopRecording();
                            _recorderState.value = RecorderState.stopped;
                            break;
                          case RecorderState.stopped:
                            locator<NavigationUtils>()
                                .push(routePublishArticle);
                            break;
                          default:
                            if (!isAccess) {
                              isAccess =
                                  await recorderPermission(context: context);
                            } else {
                              _animationController?.forward();
                              _animationController?.repeat();
                              _startOrStopRecording();
                              _recorderState.value = RecorderState.playing;
                              _isAutomaticCompletedOnce.value = false;
                            }
                            break;
                        }
                      },
                      iconSize: 30,
                      icon: _recorderState.value == RecorderState.playing
                          ? const Icon(Icons.stop, color: blackColor)
                          : const Icon(Icons.mic, color: blackColor),
                    ),
                  ),
            _recorderState.value != RecorderState.stopped
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 30,
                    child: IconButton(
                      onPressed: () {
                        _isRecordUploading.value = false;
                        _recorderState.value = RecorderState.start;
                        _animationController?.reset();
                        recorderController.stop();
                      },
                      iconSize: 30,
                      icon:
                          const Icon(Icons.refresh_rounded, color: blackColor),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }

  //API functions
  _uploadRecord(FormData formData) async {
    return await locator<AuthController>().uploadImageApiCall(
      context: context,
      formData: formData,
    );
  }
}

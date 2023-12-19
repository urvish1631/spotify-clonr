import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/context_extension.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/controllers/comments/comment_controller.dart';
import 'package:spotify_clone/src/models/articles/res_image_upload_model.dart';
import 'package:spotify_clone/src/models/comment/req_comment_model.dart';
import 'package:spotify_clone/src/providers/comment_provider.dart';
import 'package:spotify_clone/src/providers/player_provider.dart';
import 'package:spotify_clone/src/widgets/chat_bubble.dart';
import 'package:spotify_clone/src/widgets/incrementally_loading_listview.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';
import 'package:spotify_clone/src/widgets/vertical_skeleton_view.dart';

class CommentScreen extends StatefulWidget {
  final int? articleId;
  const CommentScreen({Key? key, this.articleId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  //Variables
  RecorderController recorderController = RecorderController();
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  late Directory appDirectory;
  Timer? timer;
  String? filePath;
  int count = 0;
  List<PlayerController> listOfControllers = [];
  PlayerProvider playerProvider = PlayerProvider();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isAccess = false;
  bool isUpload = false;

  //Void functions
  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  _getRecorderPermission(context) async {
    isAccess = await recorderPermission(context: context);
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        timer?.cancel();
        recorderController.reset();
        filePath = await recorderController.stop(false) ?? '';

        if (filePath != null) {
          isRecordingCompleted = true;
        }
      } else {
        if (playerProvider.audioPlayer.playing) {
          playerProvider.audioPlayer.pause();
        }
        setState(() {
          isRecordingCompleted = false;
        });
        await recorderController.record(path: path ?? "");
        timer = Timer(const Duration(seconds: 30), () {
          _startOrStopRecording();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  uploadFileAndCreateComment() async {
    setState(() {
      isUpload = true;
    });
    final formData = FormData.fromMap({'mediaType': comment});
    final image = MapEntry(
      'file',
      await MultipartFile.fromFile(
        filePath ?? '',
        contentType: getImageContentType(filePath: filePath ?? ''),
      ),
    );
    formData.files.add(image);
    final ResImageUploadModel response = await _uploadImage(formData);
    if ((response.data ?? "").isNotEmpty) {
      await createComments(response.data ?? '');
    }
    setState(() {
      isUpload = false;
      isRecordingCompleted = false;
    });
  }

  createComments(String file) {
    locator<CommentController>().createCommentOfArticle(
        context: context,
        articleId: widget.articleId ?? 0,
        model: ReqCommentSectionModel(
          commentFile: file,
        ));
  }

  _uploadImage(FormData formData) async {
    return await locator<AuthController>().uploadImageApiCall(
      context: context,
      formData: formData,
    );
  }

  //APi functions
  _getArticleComments(int page) async {
    await locator<CommentController>().getAllComments(
        context: context, articleId: widget.articleId ?? 0, page: page);
  }

  Future<void> _refreshData() async {
    _refreshKey.currentState?.show();
    Provider.of<CommentProvider>(context, listen: false).clearPage();
    await _getArticleComments(1);
  }

  //Life cycle methods
  @override
  void initState() {
    super.initState();
    if (!isAccess) {
      _getRecorderPermission(context);
    }
    _getDir();
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    _getArticleComments(1);
    _initialiseControllers();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  //Build method
  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
        builder: (context, commentProvider, child) {
      return Stack(
        children: [
          (commentProvider.articleComments ?? []).isEmpty &&
                  !(isRecordingCompleted) &&
                  commentProvider.isApiCalled != false
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: getEmptyTextWidget(
                      text: Localization.of().msgCommentsEmpty),
                )
              : const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getListOfComments(commentProvider),
              getRecorderButton(),
            ],
          ),
        ],
      );
    }).titleScaffold(
      context: context,
      isTopRequired: false,
      appBar: AppBar(
        centerTitle: true,
        title: ThemeText(
          text: Localization.of().comments,
          lightTextColor: whiteColor,
          fontSize: fontSize16,
        ),
      ),
    );
  }

  // Widgets
  Widget getRecorderButton() => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isRecording
                    ? AudioWaveforms(
                        enableGesture: true,
                        size: Size(context.getWidth() / 2, 50),
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
                      )
                    : Container(),
              ),
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 30,
                backgroundColor: primaryColor,
                child: IconButton(
                  onPressed: () async {
                    if (!isAccess) {
                      isAccess = await recorderPermission(context: context);
                    } else {
                      _startOrStopRecording();
                    }
                  },
                  icon: Icon(isRecording ? Icons.stop : Icons.mic),
                  color: blackColor,
                  iconSize: 28,
                ),
              ),
              isRecordingCompleted
                  ? IconButton(
                      onPressed: !isUpload ? uploadFileAndCreateComment : () {},
                      icon: const CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: secondaryColor,
                        child: Icon(
                          Icons.send_rounded,
                          color: whiteColor,
                        ),
                      ),
                    )
                  : const SizedBox(width: 16),
            ],
          ),
        ),
      );

  Widget getListOfComments(CommentProvider commentProvider) {
    return commentProvider.isApiCalled == false &&
            count == (commentProvider.articleComments ?? []).length
        ? const VerticalSkeletonView(
            hPadding: 16,
            height: 100,
          )
        : Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: () => _refreshData(),
              child: IncrementallyLoadingListView(
                padding: const EdgeInsets.only(
                    top: 30.0, right: 18.0, left: 18.0, bottom: 10.0),
                hasMore: () => commentProvider.hasMoreItems,
                itemCount: () => commentProvider.commentsCount,
                loadMore: () => _getArticleComments(commentProvider.page),
                itemBuilder: (_, index) {
                  return CommentAudioPlayer(
                    onFileDownload: (value) {
                      setState(() {
                        count = count + value;
                      });
                    },
                    controller: commentProvider.listController,
                    fromRecorder: false,
                    index: index,
                    user: (commentProvider.articleComments ?? [])[index].user,
                    recordedFile: (commentProvider.articleComments ?? [])[index]
                        .commentFile,
                    isSender: getInt(prefkeyId) ==
                        (commentProvider.articleComments ?? [])[index].userId,
                    width: context.getWidth() / 2,
                    appDirectory: appDirectory,
                    commentId:
                        ((commentProvider.articleComments ?? [])[index].id ?? 0)
                            .toInt(),
                    articleId: widget.articleId ?? 0,
                  );
                },
              ),
            ),
          );
  }
}

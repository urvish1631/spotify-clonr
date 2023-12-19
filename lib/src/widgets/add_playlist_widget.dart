import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/controllers/playlist/playlist_controller.dart';
import 'package:spotify_clone/src/providers/playlist_provider.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class AddToPlaylistWidget extends StatefulWidget {
  final int? articleId;
  const AddToPlaylistWidget({Key? key, this.articleId}) : super(key: key);

  @override
  State<AddToPlaylistWidget> createState() => _AddToPlaylistWidgetState();
}

class _AddToPlaylistWidgetState extends State<AddToPlaylistWidget> {
  //Variables
  final _selectedPlaylist = ValueNotifier<int>(0);

  //Life cycle methods
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getListOfPlaylist();
    });
    super.initState();
  }

  //API functions
  getListOfPlaylist() {
    locator<PlaylistController>().listOfPlaylistApi(context: context);
  }

  addToPlaylist(int? id) {
    locator<PlaylistController>().addArticleInPlaylistApi(
      context: context,
      playlistId: id ?? 0,
      articleId: widget.articleId ?? 0,
    );
  }

  //Build methods
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            decoration: const BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Consumer<PlaylistProvider>(
                builder: (context, playlistProvider, child) {
              var playlistData = playlistProvider.playlist;
              return (playlistData ?? []).isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ThemeText(
                          text: Localization.of().noPlaylistMessage,
                          lightTextColor: whiteColor,
                          fontSize: fontSize16,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          buttonText: Localization.of().createPlaylist,
                          buttonColor: primaryColor,
                          onButtonClick: () {
                            getPlaylistActions(
                              isUpdateTrue: false,
                              context: context,
                            );
                          },
                        ),
                      ],
                    )
                  : ValueListenableBuilder(
                      valueListenable: _selectedPlaylist,
                      builder: (context, int selectedPlaylist, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ListView.builder(
                                controller: controller,
                                shrinkWrap: true,
                                itemCount: playlistData?.length,
                                itemBuilder: (context, index) {
                                  return (playlistData ?? []).isNotEmpty
                                      ? RadioListTile<int?>(
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: _getTitle(
                                              playlistData?[index].name ?? '',
                                              playlistData?[index].imageURL ??
                                                  ""),
                                          value: playlistData?[index].id,
                                          groupValue: selectedPlaylist,
                                          onChanged: (value) {
                                            _selectedPlaylist.value =
                                                value ?? 0;
                                          },
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 18.0),
                              child: PrimaryButton(
                                buttonText: Localization.of().save,
                                buttonColor: primaryColor,
                                onButtonClick: () {
                                  addToPlaylist(_selectedPlaylist.value);
                                },
                              ),
                            ),
                          ],
                        );
                      });
            }),
          ),
        );
      },
    );
  }

  Widget _getTitle(String title, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: [
          imageUrl.isNotEmpty
              ? ProfileImageView(imageUrl: imageUrl, size: 50)
              : const ProfileImageView(imageUrl: dummyImage, size: 50),
          const SizedBox(
            width: 20,
          ),
          ThemeText(
            text: title,
            lightTextColor: whiteColor,
            fontSize: fontSize18,
          ),
        ],
      ),
    );
  }
}

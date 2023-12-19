import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/string_extension.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/controllers/playlist/playlist_controller.dart';
import 'package:spotify_clone/src/models/articles/res_image_upload_model.dart';
import 'package:spotify_clone/src/models/playlist/req_playlist_model.dart';
import 'package:spotify_clone/src/widgets/customdialogs/cupertino_error_dialog.dart';
import 'package:spotify_clone/src/widgets/customdialogs/material_error_dialog.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/primary_text_field.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class BottomModalSheet extends StatefulWidget {
  final bool? isUpdateTrue;
  final int? playlistId;
  final ReqPlaylistModel? playlistData;

  const BottomModalSheet(
      {Key? key, this.playlistData, this.playlistId, this.isUpdateTrue})
      : super(key: key);

  @override
  State<BottomModalSheet> createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {
  //Variables
  final _pickedImage = ValueNotifier<File?>(null);
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isUpload = false;

  _createPlaylist(imageUrl) async {
    await locator<PlaylistController>().createPlaylistApi(
        context: context,
        model: ReqPlaylistModel(
          name: _nameController.text,
          imageURL: imageUrl,
        ));
    setState(() {
      isUpload = false;
    });
  }

  _updatePlaylist(String? imageUrl) async {
    await locator<PlaylistController>().updatePlaylistApi(
      context: context,
      model: ReqPlaylistModel(
        name: _nameController.text,
        imageURL: imageUrl,
      ),
      playlistId: widget.playlistId ?? 0,
    );
    setState(() {
      isUpload = false;
    });
  }

  _uploadImage(FormData formData) async {
    return await locator<AuthController>().uploadImageApiCall(
      context: context,
      formData: formData,
    );
  }

  @override
  void initState() {
    if (widget.isUpdateTrue ?? false) {
      _nameController.text = widget.playlistData?.name ?? "";
    }
    super.initState();
  }

  //Build methods
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.6,
      builder: (_, controller) {
        return GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          child: ValueListenableBuilder(
            valueListenable: _pickedImage,
            builder: (context, File? image, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                decoration: const BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.remove,
                      color: Colors.grey[600],
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          controller: controller,
                          children: [
                            const SizedBox(height: 20.0),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                getImageBottomSheet(
                                    context: context,
                                    onGalleryClick: () async {
                                      _pickedImage.value = await getImage(
                                        context: context,
                                        pickFromCamera: false,
                                      );
                                    },
                                    onCameraClick: () async {
                                      _pickedImage.value = await getImage(
                                        context: context,
                                        pickFromCamera: true,
                                      );
                                    });
                              },
                              child: Column(
                                children: [
                                  (widget.playlistData?.imageURL ?? '')
                                              .isNotEmpty &&
                                          (image ?? File('')).path.isEmpty
                                      ? ProfileImageView(
                                          imageUrl:
                                              widget.playlistData?.imageURL ??
                                                  "",
                                          size: 100,
                                        )
                                      : (image ?? File('')).path.isNotEmpty
                                          ? ClipOval(
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.file(
                                                  image ?? File(''),
                                                  fit: BoxFit.cover,
                                                  width: 200,
                                                ),
                                              ),
                                            )
                                          : const ProfileImageView(
                                              imageUrl: dummyImage,
                                              size: 100,
                                            ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.camera_alt_outlined),
                                      const SizedBox(width: 10.0),
                                      ThemeText(
                                        text: Localization.of().uploadPhoto,
                                        lightTextColor: whiteColor,
                                        fontSize: fontSize16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            PrimaryTextField(
                              hint: Localization.of().playlistName,
                              focusNode: _nameFocus,
                              type: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              controller: _nameController,
                              validateFunction: (value) {
                                return value.toString().isFieldEmpty(
                                    Localization.of().msgPlaylistNameEmpty);
                              },
                            ),
                            const SizedBox(height: 20.0),
                            PrimaryButton(
                              buttonText: widget.isUpdateTrue ?? false
                                  ? Localization.of().update
                                  : Localization.of().create,
                              buttonColor: primaryColor,
                              onButtonClick: !isUpload
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        isUpload = true;
                                        if (widget.isUpdateTrue ?? false) {
                                          if (_pickedImage.value != null) {
                                            final formData = FormData.fromMap(
                                                {'mediaType': profileImage});
                                            final playlistImage = MapEntry(
                                              'file',
                                              await MultipartFile.fromFile(
                                                _pickedImage.value!.path,
                                                contentType:
                                                    getImageContentType(
                                                        filePath: _pickedImage
                                                            .value!.path),
                                              ),
                                            );
                                            formData.files.add(playlistImage);
                                            final ResImageUploadModel response =
                                                await _uploadImage(formData);
                                            if ((response.data ?? "")
                                                .isNotEmpty) {
                                              _updatePlaylist(response.data);
                                            }
                                          } else {
                                            _updatePlaylist(
                                                widget.playlistData?.imageURL);
                                          }
                                        } else {
                                          if (_pickedImage.value != null) {
                                            final formData = FormData.fromMap(
                                                {'mediaType': profileImage});
                                            final playlistImage = MapEntry(
                                              'file',
                                              await MultipartFile.fromFile(
                                                _pickedImage.value!.path,
                                                contentType:
                                                    getImageContentType(
                                                        filePath: _pickedImage
                                                            .value!.path),
                                              ),
                                            );
                                            formData.files.add(playlistImage);
                                            final ResImageUploadModel response =
                                                await _uploadImage(formData);
                                            if ((response.data ?? "")
                                                .isNotEmpty) {
                                              _createPlaylist(response.data);
                                            }
                                          } else {
                                            _createPlaylist("");
                                          }
                                        }
                                      }
                                    }
                                  : () {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  showDialogForEmptyImage(BuildContext ctx) {
    return showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return Platform.isIOS
            ? CupertinoErrorDialog(
                isCancelEnable: true,
                message: Localization.of().selectImageMessage,
              )
            : MaterialErrorDialog(
                isCancelEnable: true,
                message: Localization.of().selectImageMessage,
              );
      },
    );
  }
}

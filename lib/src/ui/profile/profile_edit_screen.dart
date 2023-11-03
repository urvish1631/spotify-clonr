import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/extensions/scaffold_extension.dart';
import 'package:sada_app/src/base/extensions/string_extension.dart';
import 'package:sada_app/src/base/utils/common_methods.dart';
import 'package:sada_app/src/base/utils/common_ui_methods.dart';
import 'package:sada_app/src/base/utils/constants/app_constant.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/fontsize_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/constants/navigation_route_constants.dart';
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/models/articles/res_image_upload_model.dart';
import 'package:sada_app/src/models/creator/req_profile_update_model.dart';
import 'package:sada_app/src/widgets/popmenu_widget.dart';
import 'package:sada_app/src/widgets/primary_button.dart';
import 'package:sada_app/src/widgets/primary_text_field.dart';
import 'package:sada_app/src/widgets/profile_image_view.dart';
import 'package:sada_app/src/widgets/themewidgets/theme_text.dart';

class EditProfileScreen extends StatefulWidget {
  final String? imageUrl;
  const EditProfileScreen({Key? key, this.imageUrl}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _pickedImage = ValueNotifier<File?>(null);
  bool isUpload = false;
  bool isCameraAccess = false;
  bool isMediaAccess = false;

  @override
  void initState() {
    _nameController.text = getString(prefkeyUserName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Form(
            key: _formKey,
            child: ValueListenableBuilder(
                valueListenable: _pickedImage,
                builder: (context, File? pickImage, child) {
                  return Column(
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
                                    context: context, pickFromCamera: false);
                              },
                              onCameraClick: () async {
                                _pickedImage.value = await getImage(
                                    context: context, pickFromCamera: true);
                              });
                        },
                        child: Column(
                          children: [
                            (widget.imageUrl ?? '').isNotEmpty &&
                                    (pickImage ?? File('')).path.isEmpty
                                ? ProfileImageView(
                                    imageUrl: widget.imageUrl ?? "",
                                    size: 100,
                                  )
                                : (pickImage ?? File('')).path.isNotEmpty
                                    ? ClipOval(
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.file(
                                            pickImage ?? File(''),
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
                      _getNameTextField(),
                      // const SizedBox(height: 20.0),
                      // _getPasswordTextField(),
                      const SizedBox(height: 20.0),
                      _getUpdateButton(),
                    ],
                  );
                })),
      ),
    ).titleScaffold(
        context: context,
        isTopRequired: true,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              icon: SvgPicture.asset(
                icMore,
                height: 20,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child:
                      PopupTextButton(text: Localization.of().updatePassword),
                ),
              ],
              offset: const Offset(0, 0),
              color: secondaryColor,
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  setBool(prefkeyResetPasswordFromProfile, true);
                  locator<NavigationUtils>().push(routeConfirmPassword);
                }
              },
            )
          ],
          title: ThemeText(
            text: Localization.of().editProfile,
            lightTextColor: whiteColor,
            fontSize: fontSize16,
          ),
        ));
  }

  Widget _getNameTextField() {
    return PrimaryTextField(
      hint: Localization.of().name,
      focusNode: _nameFocus,
      type: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _nameController,
      onFieldSubmitted: (value) {
        _nameFocus.unfocus();
      },
      validateFunction: (value) {
        return value!.isFieldEmpty("Please enter your name.");
      },
    );
  }

  Widget _getUpdateButton() {
    return PrimaryButton(
      buttonText: Localization.of().update,
      buttonColor: primaryColor,
      onButtonClick: !isUpload
          ? () async {
              if (_formKey.currentState!.validate()) {
                isUpload = true;
                if (_pickedImage.value != null) {
                  final formData = FormData.fromMap({'mediaType': userImage});
                  final image = MapEntry(
                    'file',
                    await MultipartFile.fromFile(
                      _pickedImage.value!.path,
                      contentType: getImageContentType(
                          filePath: _pickedImage.value!.path),
                    ),
                  );
                  formData.files.add(image);
                  final ResImageUploadModel response =
                      await _uploadImage(formData);
                  if ((response.data ?? "").isNotEmpty) {
                    await _updateProfileAPI(response.data);
                  }
                } else {
                  _updateProfileAPI(widget.imageUrl);
                }
              }
            }
          : () {},
    );
  }

  //API calling functions
  _updateProfileAPI(url) async {
    await locator<AuthController>().updateProfileApiCall(
        context: context,
        model:
            ReqProfileUpdateModel(name: _nameController.text, imageURL: url));
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
}

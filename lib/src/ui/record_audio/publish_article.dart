import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/base/extensions/scaffold_extension.dart';
import 'package:spotify_clone/src/base/extensions/string_extension.dart';
import 'package:spotify_clone/src/base/utils/common_methods.dart';
import 'package:spotify_clone/src/base/utils/common_ui_methods.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/color_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/fontsize_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/image_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/controllers/article/article_controller.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/models/articles/req_article_model.dart';
import 'package:spotify_clone/src/models/articles/res_image_upload_model.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';
import 'package:spotify_clone/src/providers/article_provider.dart';
import 'package:spotify_clone/src/widgets/primary_button.dart';
import 'package:spotify_clone/src/widgets/primary_text_field.dart';
import 'package:spotify_clone/src/widgets/profile_image_view.dart';
import 'package:spotify_clone/src/widgets/themewidgets/theme_text.dart';

class PublishArticleScreen extends StatefulWidget {
  final bool? fromProfile;
  final bool? isArticleRecorded;
  final String? writtenArticle;
  final int? articleId;
  final String? recordedFile;
  final Article? articleData;
  const PublishArticleScreen({
    Key? key,
    this.fromProfile,
    this.writtenArticle,
    this.isArticleRecorded,
    this.articleData,
    this.articleId,
    this.recordedFile,
  }) : super(key: key);

  @override
  State<PublishArticleScreen> createState() => _PublishArticleScreenState();
}

class _PublishArticleScreenState extends State<PublishArticleScreen> {
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  List<String>? selectedValues = [];
  final _pickedImage = ValueNotifier<File?>(null);
  bool isValueSelected = true;
  bool isUpload = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getAllCategories();
    });
    if (widget.fromProfile ?? false) {
      _nameController.text = widget.articleData?.title ?? '';
      _getArticleDataFromId(widget.articleId ?? 0);
    }
    super.initState();
  }

  _getAllCategories() async {
    await locator<HomeController>().getAllCategoriesApi(context: context);
  }

  _getArticleDataFromId(int id) async {
    await locator<ArticleController>().getArticleById(
      context: context,
      id: widget.articleId ?? 0,
    );
  }

  _uploadImage(FormData formData) async {
    return await locator<AuthController>().uploadImageApiCall(
      context: context,
      formData: formData,
    );
  }

  _createArticleApi(String? image) {
    locator<ArticleController>().createArticleApi(
        context: context,
        model: ReqArticleModel(
          title: _nameController.text,
          articleType: widget.isArticleRecorded ?? false
              ? recordedArticle
              : writtenArticle,
          categories: selectedValues,
          imageURL: image,
          recordedFile: widget.recordedFile,
          writtenText: widget.writtenArticle,
        ));
    setState(() {
      isUpload = false;
    });
  }

  _updateArticleApi(String? image) {
    locator<ArticleController>().updateArticleApi(
      context: context,
      id: widget.articleId ?? 0,
      model: ReqArticleModel(
        title: _nameController.text,
        articleType: widget.isArticleRecorded ?? false
            ? recordedArticle
            : writtenArticle,
        categories: selectedValues,
        imageURL:
            _pickedImage.value == null ? widget.articleData?.imageURL : image,
        recordedFile: widget.recordedFile,
        writtenText: widget.writtenArticle,
      ),
    );
    setState(() {
      isUpload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: ValueListenableBuilder(
            valueListenable: _pickedImage,
            builder: (context, File? image, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    ValueListenableBuilder(
                      valueListenable: _pickedImage,
                      builder: (context, File? pickImage, child) {
                        return InkWell(
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
                              (widget.articleData?.imageURL ?? '').isNotEmpty
                                  ? ProfileImageView(
                                      imageUrl:
                                          widget.articleData?.imageURL ?? '',
                                      size: 100)
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
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    _getArticleNameField(),
                    const SizedBox(height: 20.0),
                    _selectCategory(),
                    const SizedBox(height: 20.0),
                    _getSubmitButton(),
                  ],
                ),
              );
            }),
      ),
    ).titleScaffold(
      context: context,
      isTopRequired: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.fromProfile ?? false
              ? Localization.of().editArticle
              : Localization.of().publish,
        ),
      ),
    );
  }

  Widget _getArticleNameField() {
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
        return value!.isFieldEmpty(Localization.of().msgArticleNameEmpty);
      },
    );
  }

  Widget _selectCategory() {
    return Consumer<ArticlesProvider>(
        builder: (context, articleProvider, child) {
      var allCategories = articleProvider.allCategoryList?.data;
      var selectCategory = articleProvider.singleArticle?.articleCategories;
      List<CategoryModel> selectedCategories =
          articleProvider.getListOfCategories(selectCategory ?? []);
      selectedValues = widget.fromProfile ?? false
          ? selectedCategories.map((e) => e.id.toString()).toList()
          : [];
      return GestureDetector(
        onTap: () {
          _nameFocus.unfocus();
        },
        child: MultiSelectDialogField<CategoryModel>(
          selectedItemsTextStyle: const TextStyle(color: blackColor),
          selectedColor: primaryColor,
          unselectedColor: secondaryColor,
          initialValue: widget.fromProfile ?? false ? selectedCategories : [],
          backgroundColor: blackColor,
          buttonIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          separateSelectedItems: true,
          checkColor: blackColor,
          buttonText: Text(
            Localization.of().selectCategory,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: fontSize16,
              fontWeight: fontWeightRegular,
            ),
          ),
          cancelText: Text(
            Localization.of().cancel,
            style: const TextStyle(
              color: primaryColor,
            ),
          ),
          confirmText: Text(
            Localization.of().ok,
            style: const TextStyle(
              color: primaryColor,
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: !isValueSelected
                  ? redColor
                  : Colors.grey[700] ?? Colors.white,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          title: ThemeText(
            text: Localization.of().category,
            lightTextColor: primaryColor,
            fontSize: fontSize18,
          ),
          items: (allCategories ?? [])
              .map((e) => MultiSelectItem(e, e.name ?? ''))
              .toList(),
          listType: MultiSelectListType.CHIP,
          chipDisplay: MultiSelectChipDisplay(
            chipColor: primaryColor,
            textStyle: const TextStyle(color: blackColor),
            icon: const Icon(
              Icons.check,
              color: blackColor,
            ),
          ),
          onConfirm: (List<CategoryModel?> values) {
            selectedValues = values.map((e) => e?.id.toString() ?? "").toList();
          },
          onSelectionChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                isValueSelected = true;
              });
            }
          },
        ),
      );
    });
  }

  Widget _getSubmitButton() {
    return PrimaryButton(
      buttonText: widget.fromProfile ?? false
          ? Localization.of().update
          : Localization.of().submit,
      buttonColor: primaryColor,
      onButtonClick: !isUpload
          ? () async {
              if (_formKey.currentState!.validate() &&
                  (selectedValues ?? []).isNotEmpty) {
                isUpload = true;
                if (widget.fromProfile ?? false) {
                  if (_pickedImage.value != null) {
                    final formData =
                        FormData.fromMap({'mediaType': profileImage});
                    final articleImage = MapEntry(
                      'file',
                      await MultipartFile.fromFile(
                        _pickedImage.value!.path,
                        contentType: getImageContentType(
                            filePath: _pickedImage.value!.path),
                      ),
                    );
                    formData.files.add(articleImage);
                    final ResImageUploadModel response =
                        await _uploadImage(formData);
                    if ((response.data ?? "").isNotEmpty) {
                      await _updateArticleApi(response.data);
                    }
                  } else {
                    _updateArticleApi(widget.articleData?.imageURL);
                  }
                } else {
                  if (_pickedImage.value != null) {
                    final formData =
                        FormData.fromMap({'mediaType': profileImage});
                    final articleImage = MapEntry(
                      'file',
                      await MultipartFile.fromFile(
                        _pickedImage.value!.path,
                        contentType: getImageContentType(
                            filePath: _pickedImage.value!.path),
                      ),
                    );
                    formData.files.add(articleImage);
                    final ResImageUploadModel response =
                        await _uploadImage(formData);
                    if ((response.data ?? "").isNotEmpty) {
                      await _createArticleApi(response.data);
                    }
                  } else {
                    _createArticleApi("");
                  }
                }
              } else {
                if ((selectedValues ?? []).isEmpty) {
                  setState(() {
                    isValueSelected = false;
                  });
                }
              }
            }
          : () {},
    );
  }
}

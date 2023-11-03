import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/base/utils/constants/color_constant.dart';
import 'package:sada_app/src/base/utils/constants/image_constant.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/controllers/article/article_controller.dart';
import 'package:sada_app/src/providers/search_provider.dart';
import 'package:sada_app/src/ui/home_tabbar/home_tabbar_widget.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key}) : super(key: key);

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  //Variable
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  bool typing = false;

  //Build methods
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getTextField(),
        titleSpacing: 0.0,
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Provider.of<SearchProvider>(context, listen: false).clearData();
            locator<NavigationUtils>().pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              icLeftArrow,
            ),
          ),
        ),
      ),
      body: const HomeTabBar(fromSearch: true),
    );
  }

  Widget _getTextField() {
    return Container(
      alignment: Alignment.centerLeft,
      child: TextFormField(
        cursorColor: primaryColor,
        controller: _searchController,
        focusNode: _searchFocus,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: primaryColor),
          ),
          hintText: Localization.of().searchArticle,
        ),
        onFieldSubmitted: (value) {
          _searchFocus.unfocus();
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            _searchArticlesAPI(value);
          } else {
            Provider.of<SearchProvider>(context, listen: false).clearData();
          }
        },
      ),
    );
  }

  // API functions
  _searchArticlesAPI(String value) {
    locator<ArticleController>().searchQueryApi(context: context, text: value);
  }
}

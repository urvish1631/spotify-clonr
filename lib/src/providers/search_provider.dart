import 'package:flutter/material.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';
import 'package:sada_app/src/models/category/res_category_model.dart';
import 'package:sada_app/src/models/search/res_search_model.dart';

class SearchProvider extends ChangeNotifier {
  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<Article>? _articleList;
  List<Article>? get articleList => _articleList;

  List<CategoryModel>? _artistList;
  List<CategoryModel>? get artistList => _artistList;

  bool _isApiCalled = false;
  bool get isApiCalled {
    return _isApiCalled;
  }

  addSearchData(ResSearchModel model) {
    _categoryList = model.categories;
    _artistList = model.creators;
    _articleList = model.articles;
    _isApiCalled = true;
    notifyListeners();
  }

  clearData() {
    _categoryList = [];
    _artistList = [];
    _articleList = [];
    _isApiCalled = false;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify_clone/src/models/articles/res_get_article_model.dart';
import 'package:spotify_clone/src/models/articles/res_recently_played_model.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';

class ArticlesProvider extends ChangeNotifier {
  List<Article> _listRecommendedArticles = [];
  List<Article>? get recommendedArticles => _listRecommendedArticles;

  List<CategoryModel> _listCategoryArticles = [];
  List<CategoryModel>? get categoryList => _listCategoryArticles;

  ResCategoriesModel? _allCategoryList;
  ResCategoriesModel? get allCategoryList => _allCategoryList;

  List<Article> _listOfArticles = [];
  List<Article>? get articleList => _listOfArticles;

  List<Article>? _categoryPlaylistArticles;
  List<Article>? get categoryPlaylistArticles => _categoryPlaylistArticles;

  List<RecentlyPlayedArticleModel>? _recentlyPlayed;
  List<RecentlyPlayedArticleModel>? get recentlyPlayed => _recentlyPlayed;

  List<CategoryModel> _listOfArtists = [];
  List<CategoryModel> get artistList => _listOfArtists;

  List<AudioSource>? _createPlaylist;
  List<AudioSource>? get getCreatedPlaylist => _createPlaylist;

  Article? _singleArticle;
  Article? get singleArticle => _singleArticle;

  bool _hasMoreItems = false;
  int _page = 1;
  bool _articleHasMoreItems = false;
  int _articlePage = 1;
  bool _artistHasMoreItems = false;
  int _artistPage = 1;
  bool _categoryHasMoreItems = false;
  int _categoryPage = 1;
  bool _isApiCalled = false;
  List<int> _articleIds = [];

  int get articlesCount {
    return _listOfArticles.length;
  }

  int get artistCount {
    return _listOfArtists.length;
  }

  int get recommendationsCount {
    return _listRecommendedArticles.length;
  }

  int get categoriesCount {
    return _listCategoryArticles.length;
  }

  int get page {
    return _page;
  }

  bool get hasMoreItems {
    return _hasMoreItems;
  }

  int get articlePage {
    return _articlePage;
  }

  bool get articleHasMoreItems {
    return _articleHasMoreItems;
  }

  int get artistPage {
    return _artistPage;
  }

  bool get artistHasMoreItems {
    return _artistHasMoreItems;
  }

  int get categoryPage {
    return _categoryPage;
  }

  bool get categoryHasMoreItems {
    return _categoryHasMoreItems;
  }

  bool get isApiCalled {
    return _isApiCalled;
  }

  List<int> get articleIds {
    return _articleIds;
  }

  clearPage() {
    _page = 1;
    _listRecommendedArticles = [];
    notifyListeners();
  }

  articleClearPage() {
    _articlePage = 1;
    _listOfArticles = [];
    notifyListeners();
  }

  artistClearPage() {
    _artistPage = 1;
    _listOfArtists = [];
    notifyListeners();
  }

  categoryClearPage() {
    _categoryPage = 1;
    _listCategoryArticles = [];
    notifyListeners();
  }

  addRecommendations(List<Article> recommendedArticles) {
    if (page == 1) {
      _listRecommendedArticles = [];
      _listRecommendedArticles.addAll(recommendedArticles);
    } else {
      _listRecommendedArticles.addAll(recommendedArticles);
    }
    if (hasMoreItems) {
      _page += 1;
    }
    _hasMoreItems = recommendationsCount < (_listRecommendedArticles.length);
    getListOfArticleIds(_listRecommendedArticles);
    createPlaylist(_listRecommendedArticles);
    _isApiCalled = true;
    notifyListeners();
  }

  addCategoriesList(List<CategoryModel> categoryList) {
    if (_categoryPage == 1) {
      _listCategoryArticles = [];
      _listCategoryArticles.addAll(categoryList);
    } else {
      _listCategoryArticles.addAll(categoryList);
    }
    if (categoryHasMoreItems) {
      _categoryPage += 1;
    }
    _categoryHasMoreItems = categoriesCount < (_listCategoryArticles.length);
    _isApiCalled = true;
    notifyListeners();
  }

  addArticleList(List<Article> articleList) {
    if (_articlePage == 1) {
      _listOfArticles = [];
      _listOfArticles.addAll(articleList);
    } else {
      _listOfArticles.addAll(articleList);
    }
    if (articleHasMoreItems) {
      _articlePage += 1;
    }
    _articleHasMoreItems = articlesCount < (_listOfArticles.length);
    _isApiCalled = true;
    notifyListeners();
  }

  addArtistList(List<CategoryModel> artistList) {
    if (_artistPage == 1) {
      _listOfArtists = [];
      _listOfArtists.addAll(artistList);
    } else {
      _listOfArtists.addAll(artistList);
    }
    if (artistHasMoreItems) {
      _artistPage += 1;
    }
    _artistHasMoreItems = artistCount < (_listOfArtists.length);
    _isApiCalled = true;
    notifyListeners();
  }

  createArticlesOfCategory(List<RecentlyPlayedArticleModel>? articles) {
    List<Article>? playlistData = [];
    for (var element in articles as List<RecentlyPlayedArticleModel>) {
      Article? data = element.article;
      playlistData.add(data ?? Article());
    }
    return playlistData;
  }

  allCategoriesList(ResCategoriesModel? categoryList) {
    _allCategoryList = categoryList;
    _isApiCalled = true;
    notifyListeners();
  }

  addRecentlyPlayed(List<RecentlyPlayedArticleModel>? recentlyPlayed) {
    _recentlyPlayed = recentlyPlayed;
    _categoryPlaylistArticles = createArticlesOfCategory(recentlyPlayed);
    final existing = <int?>{};
    _categoryPlaylistArticles = _categoryPlaylistArticles
        ?.where((person) => existing.add(person.id))
        .toList();
    _isApiCalled = true;
    notifyListeners();
  }

  createPlaylist(List<Article>? getArticles) {
    List<AudioSource>? createPlaylist = [];
    for (var element in getArticles ?? []) {
      Article data = element;
      if ((data.writtenText ?? '').isEmpty) {
        AudioSource source = AudioSource.uri(
          Uri.parse(data.recordedFile ?? ''),
          tag: MediaItem(
            id: '${data.id}',
            title: data.title ?? '',
            artist: data.user?.name ?? '',
            artUri: Uri.parse(data.imageURL?.trim() ?? ''),
          ),
        );
        createPlaylist.add(source);
      }
    }
    _createPlaylist = createPlaylist;
  }

  getListOfArticleIds(List<Article> articles) {
    List<int> articleIds = [];
    for (var element in articles) {
      articleIds.add(element.id ?? 0);
    }
    _articleIds = articleIds;
  }

  clearData() {
    _isApiCalled = false;
    notifyListeners();
  }

  addSingleArticle(Article? article) {
    _singleArticle = article;
    notifyListeners();
  }

  getListOfCategories(List<GetCategories> articleCategories) {
    List<int?> catIds = articleCategories.map((e) => e.categoryId).toList();
    List<CategoryModel> allCategory = allCategoryList?.data ?? [];
    List<CategoryModel> selectedCategory = [];
    for (CategoryModel category in allCategory) {
      if (catIds.contains(category.id)) {
        selectedCategory.add(category);
      }
    }
    return selectedCategory;
  }
}

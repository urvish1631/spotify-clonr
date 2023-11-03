// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:sada_app/src/models/comment/res_comment_model.dart';

class CommentProvider with ChangeNotifier {
  ResCommentSectionModel? _articleComments;
  // List<PlayerController> _listOfControllers = [];
  // List<PlayerController> get listController => _listOfControllers;
  List<CommentModel>? get articleComments => _articleComments?.data;
  bool _isApiCalled = false;

  bool _hasMoreItems = true;
  int _page = 1;

  int get page {
    return _page;
  }

  bool get isApiCalled {
    return _isApiCalled;
  }

  bool get hasMoreItems {
    return _hasMoreItems;
  }

  int get commentsCount {
    return _articleComments?.count ?? 0;
  }

  clearPage() {
    _page = 1;
    notifyListeners();
  }

  addArticleComments(ResCommentSectionModel articleComments) {
    final List<CommentModel> listOfComments = articleComments.data ?? [];
    _articleComments = articleComments;
    _articleComments?.data = [];
    _articleComments?.data?.addAll(listOfComments);
    if (hasMoreItems) {
      _page += 1;
    }
    _hasMoreItems = commentsCount < (_articleComments?.data?.length ?? 0);
    createListOfController();
    _isApiCalled = true;
    notifyListeners();
  }

  createListOfController() {
    // _listOfControllers = [];
    // for (var i = 0; i < (_articleComments?.data ?? []).length; i++) {
    //   _listOfControllers.add(PlayerController());
    // }
  }

  clearComment() {
    _page = 1;
    _articleComments?.data = [];
    _isApiCalled = false;
  }
}

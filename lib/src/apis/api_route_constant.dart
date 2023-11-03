// Auth Api Endpoints
import 'package:sada_app/src/base/utils/constants/preference_key_constant.dart';
import 'package:sada_app/src/base/utils/preference_utils.dart';

const String apiLogin = "/user/signin";
const String apiSignUp = "/user/signup";
const String apiVerifyOtp = "/user/verifyOtp";
const String apiResendOtp = "/user/resend-otp";
const String apiForgotPassword = "/user/forgot-password";
const String apiResetPassword = "/user/reset-password";

//Profile Screen API Endpoints
const String apiUpdatePassword = '/profile/user/password-update';
const String apiUpdateProfile = '/profile/user/profile-update'; 
const String apiDeleteProfile = '/profile/delete-account'; 
const String apiUserProfile = '/profile/user';
String apiCreatorProfile(int id) {
  if (id == getInt(prefkeyId)) {
    return '/profile/creator-profile/$id';
  } else {
    return '/profile/creator/$id';
  }
}

String apiFollowCreator(id) {
  return '/profile/follow/creator/$id';
}

String apiArticleByCategory(id) {
  return '/home/category/$id/article';
}

String apiTrackPlayer(id) {
  return '/audio/$id/track-played';
}

//Home Screen API Endpoints
const String apiRecommendations = '/home/recommendation/article';
const String apiCategory = '/home/category';
const String apiAllCategory = '/home/category/all';

const String apiArticle = '/home/article';
const String apiGetArtist = '/home/creator';

String apiForParticularArticleList(String apiEndpoint, int id) {
  return '$apiEndpoint/$id/article';
}

//Recently played
const String apiRecentlyPlayed = '/audio/recently-played';

//Image Upload
const String apiMediaUpload = '/media/upload';

//Playlist Api
const String apiCreatePlaylist = '/playlist';
String apiEditDeletePlaylist(int id) {
  return '/playlist/$id';
}

String apiLikeArticle(int id) {
  return '/article/$id/like';
}

String apiDeletArticle(int id) {
  return '/article/$id';
}

String apiGetArticleComments(int id) {
  return '/comment/article/$id';
}

String apiCreateComment(int articleId) {
  return '/comment/$articleId';
}

String apiGetPlaylistArticle(int id) {
  return '/playlist/$id/article';
}

String apiArticlePlaylist(int id, int articleId, bool isAdd) {
  if (isAdd) {
    return '/playlist/$id/add-article/$articleId';
  } else {
    return '/playlist/$id/remove-article/$articleId';
  }
}

const String apiCreateArticle = '/article/article';
const String apiChangeLanguage = '/setting/language';
String apiUpdateArticle(id) {
  return '/article/$id';
}

const String apiSearchQuery = '/article/search';

import 'package:get_it/get_it.dart';
import 'package:spotify_clone/src/apis/api_service.dart';
import 'package:spotify_clone/src/apis/apimanagers/article_api_manager.dart';
import 'package:spotify_clone/src/apis/apimanagers/auth_api_manager.dart';
import 'package:spotify_clone/src/apis/apimanagers/comment_api_manager.dart';
import 'package:spotify_clone/src/apis/apimanagers/home_api_manager.dart';
import 'package:spotify_clone/src/apis/apimanagers/playlist_api_manager.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/controllers/article/article_controller.dart';
import 'package:spotify_clone/src/controllers/auth/auth_controller.dart';
import 'package:spotify_clone/src/controllers/comments/comment_controller.dart';
import 'package:spotify_clone/src/controllers/home/home_controller.dart';
import 'package:spotify_clone/src/controllers/playlist/playlist_controller.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Common
  locator.registerSingleton<NavigationUtils>(NavigationUtils());
  locator.registerSingleton<ApiService>(ApiService());

  // API Managers
  locator.registerSingleton<AuthApiManager>(AuthApiManager());
  locator.registerSingleton<HomeApiManager>(HomeApiManager());
  locator.registerSingleton<ArticleApiManager>(ArticleApiManager());
  locator.registerSingleton<CommentApiManager>(CommentApiManager());
  locator.registerSingleton<PlaylistApiManger>(PlaylistApiManger());

  // Controller
  locator.registerSingleton<AuthController>(AuthController());
  locator.registerSingleton<HomeController>(HomeController());
  locator.registerSingleton<ArticleController>(ArticleController());
  locator.registerSingleton<CommentController>(CommentController());
  locator.registerSingleton<PlaylistController>(PlaylistController());
}

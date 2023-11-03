import 'package:get_it/get_it.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/apis/apimanagers/article_api_manager.dart';
import 'package:sada_app/src/apis/apimanagers/auth_api_manager.dart';
import 'package:sada_app/src/apis/apimanagers/comment_api_manager.dart';
import 'package:sada_app/src/apis/apimanagers/home_api_manager.dart';
import 'package:sada_app/src/apis/apimanagers/playlist_api_manager.dart';
import 'package:sada_app/src/base/utils/navigation_utils.dart';
import 'package:sada_app/src/controllers/article/article_controller.dart';
import 'package:sada_app/src/controllers/auth/auth_controller.dart';
import 'package:sada_app/src/controllers/comments/comment_controller.dart';
import 'package:sada_app/src/controllers/home/home_controller.dart';
import 'package:sada_app/src/controllers/playlist/playlist_controller.dart';

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

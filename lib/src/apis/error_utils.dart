import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:sada_app/src/base/utils/dialog_utils.dart';
import 'package:sada_app/src/base/utils/localization/localization.dart';
import 'package:sada_app/src/base/utils/progress_dialog_utils.dart';

Future<void> handleHttpError(DioError e) async {
  switch (e.type) {
    case DioErrorType.connectionTimeout:
      showAlertDialog(
        message: Localization.of().poorInternetConnection,
        isCancelEnable: false,
        okButtonAction: () {
          ProgressDialogUtils.dismissProgressDialog();
        },
      );
      break;
    case DioErrorType.badResponse:
      if (e.response?.statusCode == 401) {
        showAlertDialog(
          message: e.response?.data["error"] ?? "",
          isCancelEnable: false,
          okButtonAction: () {
            ProgressDialogUtils.dismissProgressDialog();
          },
        );
      } else {
        showAlertDialog(
          message: e.response?.data["error"] ?? "",
          isCancelEnable: false,
          okButtonAction: () {
            ProgressDialogUtils.dismissProgressDialog();
          },
        );
      }
      break;
    default:
      showAlertDialog(
        message: e.error.toString(),
        isCancelEnable: false,
        okButtonAction: () {
          ProgressDialogUtils.dismissProgressDialog();
        },
      );
  }
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  showAlertDialog(
    message: Localization.of().internetNotConnected,
  );
  return false;
}

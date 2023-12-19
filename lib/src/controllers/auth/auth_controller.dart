import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/src/apis/apimanagers/auth_api_manager.dart';
import 'package:spotify_clone/src/base/utils/constants/app_constant.dart';
import 'package:spotify_clone/src/base/utils/constants/navigation_route_constants.dart';
import 'package:spotify_clone/src/base/utils/constants/preference_key_constant.dart';
import 'package:spotify_clone/src/base/utils/localization/localization.dart';
import 'package:spotify_clone/src/base/utils/navigation_utils.dart';
import 'package:spotify_clone/src/base/utils/preference_utils.dart';
import 'package:spotify_clone/src/base/utils/progress_dialog_utils.dart';
import 'package:spotify_clone/src/models/articles/res_image_upload_model.dart';
import 'package:spotify_clone/src/models/auth/login/req_login_model.dart';
import 'package:spotify_clone/src/base/dependencyinjection/locator.dart';
import 'package:spotify_clone/src/models/auth/login/res_login_model.dart';
import 'package:spotify_clone/src/models/auth/otp/req_otp_model.dart';
import 'package:spotify_clone/src/models/auth/otp/req_resend_otp_model.dart';
import 'package:spotify_clone/src/models/auth/reset_password/req_reset_password_model.dart';
import 'package:spotify_clone/src/models/auth/signup/req_signup_model.dart';
import 'package:spotify_clone/src/models/auth/update_password/req_update_password_model.dart';
import 'package:spotify_clone/src/models/creator/req_profile_update_model.dart';
import 'package:spotify_clone/src/providers/bottom_tabbar_provider.dart';
import 'package:spotify_clone/src/providers/profile_data.provider.dart';
import 'package:spotify_clone/src/widgets/toast_widget.dart';

class AuthController {
  loginApiCall(
      {required BuildContext context, required ReqLoginModel model}) async {
    await locator<AuthApiManager>().login(model).then(
      (data) {
        if (!(data.user?.isOtpVerified ?? false)) {
          _setDataSignUp(data);
          locator<NavigationUtils>().pushAndRemoveUntil(routeOtp);
        } else {
          _setDataSignUp(data);
          Provider.of<BottomTabBarProvider>(context, listen: false).setIndex(0);
          Provider.of<ProfileDataProvider>(context, listen: false)
              .addProfileData(data.user);
          locator<NavigationUtils>().pushAndRemoveUntil(routeTabBar);
          ToastUtils.showSuccess(message: Localization.of().loginSuccessfully);
        }
      },
    );
  }

  signupApiCall(
      {required BuildContext context, required ReqSignUpModel model}) async {
    ProgressDialogUtils.showProgressDialog();
    await locator<AuthApiManager>().signUp(model).then(
      (data) {
        setBool(prefkeyIsCreatorRegistered, true);
        ProgressDialogUtils.dismissProgressDialog();
        _setDataSignUp(data);
        Provider.of<ProfileDataProvider>(context, listen: false)
            .addProfileData(data.user);
        locator<NavigationUtils>().push(routeOtp);
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  verifyOtpApiCall(
      {required BuildContext context, required ReqOtpModel model}) async {
    await locator<AuthApiManager>().verifyOtp(model).then(
      (data) {
        if (getBool(prefkeyIsForgotPassword)) {
          setBool(prefkeyIsForgotPassword, false);
          locator<NavigationUtils>().pushAndRemoveUntil(routeConfirmPassword);
        } else {
          if (!getBool(prefkeyIsCreatorApproved) && getBool(prefkeyIsCreator)) {
            locator<NavigationUtils>().pushAndRemoveUntil(routeLogin);
          } else {
            Provider.of<BottomTabBarProvider>(context, listen: false)
                .setIndex(0);
            locator<NavigationUtils>().pushAndRemoveUntil(routeTabBar);
          }
        }
        ToastUtils.showSuccess(message: data.message ?? '');
      },
    );
  }

  resendOtpApiCall(
      {required BuildContext context, required ReqResendOtpModel model}) async {
    await locator<AuthApiManager>().resendOtp(model).then(
      (data) {
        setString(prefkeyOTP, data.otp ?? '');
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  forgotPasswordApiCall(
      {required BuildContext context, required ReqResendOtpModel model}) async {
    await locator<AuthApiManager>().forgotPassword(model).then(
      (data) {
        setBool(prefkeyIsForgotPassword, true);
        setBool(prefkeyResetPasswordFromProfile, false);
        setString(prefkeyOTP, data.otp ?? '');
        locator<NavigationUtils>().push(routeOtp);
      },
    );
  }

  resetPasswordApiCall(
      {required BuildContext context,
      required ReqResetPasswordModel model}) async {
    await locator<AuthApiManager>().resetPassword(model).then(
      (data) {
        setBool(prefkeyIsForgotPassword, false);
        locator<NavigationUtils>().pushAndRemoveUntil(routeLogin);
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  getCreatorProfile({required BuildContext context, required int id}) async {
    await locator<AuthApiManager>().getCreatorProfile(id).then(
      (data) {
        if (id == getInt(prefkeyId)) {
          Provider.of<ProfileDataProvider>(context, listen: false)
              .addCreatorProfileData(data);
          setBool(prefkeyIsCreator, true);
          setString(prefkeyUserName, data.creatorProfile?.creator?.name ?? '');
        } else {
          Provider.of<ProfileDataProvider>(context, listen: false)
              .addArtistProfileData(data);
        }
      },
    );
  }

  getUserProfile({required BuildContext context}) async {
    await locator<AuthApiManager>().getUserProfile().then(
      (data) {
        Provider.of<ProfileDataProvider>(context, listen: false)
            .addUserProfile(data);
        setBool(prefkeyIsUser, true);
        setString(prefkeyUserName, data.userProfile?.user?.name ?? '');
      },
    );
  }

  updatePasswordApiCall({
    required BuildContext context,
    required ReqPasswordUpdateModel model,
  }) async {
    await locator<AuthApiManager>().updatePasswordFromProfile(model).then(
      (data) {
        locator<NavigationUtils>().pop();
        setBool(prefkeyResetPasswordFromProfile, false);
        ToastUtils.showSuccess(message: data.msg ?? '');
      },
    );
  }

  updateProfileApiCall({
    required BuildContext context,
    required ReqProfileUpdateModel model,
  }) async {
    await locator<AuthApiManager>().updateProfile(model).then(
      (data) {
        ToastUtils.showSuccess(message: data.msg ?? '');
        Provider.of<ProfileDataProvider>(context, listen: false)
            .addProfileData(data.data);
        if (getBool(prefkeyIsCreator)) {
          getCreatorProfile(context: context, id: getInt(prefkeyId));
        } else {
          getUserProfile(context: context);
        }
        locator<NavigationUtils>().pop();
      },
    );
  }

  deleteProfileApiCall({
    required BuildContext context,
  }) async {
    ProgressDialogUtils.showProgressDialog();
    await locator<AuthApiManager>().deleteProfile().then(
      (data) {
        ProgressDialogUtils.dismissProgressDialog();
        ToastUtils.showSuccess(message: data.msg ?? '');
        locator<NavigationUtils>().pushAndRemoveUntil(routeChooseRole);
      },
    );
  }

  Future<ResImageUploadModel> uploadImageApiCall(
      {required BuildContext context, required FormData formData}) async {
    return await locator<AuthApiManager>().imageUpload(formData);
  }

  _setDataSignUp(ResLoginModel model) async {
    await setInt(prefkeyId, model.user?.id ?? 0);
    await setString(prefkeyToken, model.token ?? '');
    await setString(prefkeyUserName, model.user?.name ?? '');
    await setString(prefkeyEmailAddress, model.user?.email ?? '');
    await setBool(prefkeyIsCreator, model.user?.userType == creator);
    await setBool(prefkeyIsUser, model.user?.userType == user);
    if (getBool(prefkeyIsCreator)) {
      await setBool(
          prefkeyIsCreatorApproved, model.user?.isCreatorApproved ?? false);
    }
    await setBool(prefkeyIsOtpVerified, model.user?.isOtpVerified ?? false);
    await setString(prefkeyOTP, model.user?.otp ?? '');
  }
}

import 'package:dio/dio.dart';
import 'package:sada_app/src/apis/api_route_constant.dart';
import 'package:sada_app/src/apis/api_service.dart';
import 'package:sada_app/src/base/dependencyinjection/locator.dart';
import 'package:sada_app/src/models/articles/res_image_upload_model.dart';
import 'package:sada_app/src/models/auth/login/req_login_model.dart';
import 'package:sada_app/src/models/auth/login/res_login_model.dart';
import 'package:sada_app/src/models/auth/otp/req_otp_model.dart';
import 'package:sada_app/src/models/auth/otp/req_resend_otp_model.dart';
import 'package:sada_app/src/models/auth/otp/res_otp_model.dart';
import 'package:sada_app/src/models/auth/otp/res_resend_otp_model.dart';
import 'package:sada_app/src/models/auth/reset_password/req_reset_password_model.dart';
import 'package:sada_app/src/models/auth/signup/req_signup_model.dart';
import 'package:sada_app/src/models/auth/update_password/req_update_password_model.dart';
import 'package:sada_app/src/models/creator/req_profile_update_model.dart';
import 'package:sada_app/src/models/creator/res_creator_profile_model.dart';
import 'package:sada_app/src/models/creator/res_profile_update_model.dart';
import 'package:sada_app/src/models/res_base_model.dart';
import 'package:sada_app/src/models/user/res_user_profile_model.dart';

class AuthApiManager {
  Future<ResLoginModel> login(ReqLoginModel request) async {
    final response = await locator<ApiService>().post(
      apiLogin,
      data: request.toJson(),
    );
    return ResLoginModel.fromJson(response?.data);
  }

  Future<ResLoginModel> signUp(ReqSignUpModel request) async {
    final response = await locator<ApiService>().post(
      apiSignUp,
      data: request.toJson(),
    );
    return ResLoginModel.fromJson(response?.data);
  }

  Future<ResOtpModel> verifyOtp(ReqOtpModel request) async {
    final response = await locator<ApiService>().post(
      apiVerifyOtp,
      data: request.toJson(),
    );
    return ResOtpModel.fromJson(response?.data);
  }

  Future<ResResendOtpModel> resendOtp(ReqResendOtpModel request) async {
    final response = await locator<ApiService>().post(
      apiResendOtp,
      data: request.toJson(),
    );
    return ResResendOtpModel.fromJson(response?.data);
  }

  Future<ResResendOtpModel> forgotPassword(ReqResendOtpModel request) async {
    final response = await locator<ApiService>().post(
      apiForgotPassword,
      data: request.toJson(),
    );
    return ResResendOtpModel.fromJson(response?.data);
  }

  Future<ResBaseModel> resetPassword(ReqResetPasswordModel request) async {
    final response = await locator<ApiService>().post(
      apiResetPassword,
      data: request.toJson(),
    );
    return ResBaseModel.fromJson(response?.data);
  }

  Future<ResCreatorProfileModel> getCreatorProfile(int id) async {
    final response = await locator<ApiService>().get(
      apiCreatorProfile(id),
    );
    return ResCreatorProfileModel.fromJson(response?.data);
  }

  Future<ResUserProfileModel> getUserProfile() async {
    final response = await locator<ApiService>().get(apiUserProfile);
    return ResUserProfileModel.fromJson(response?.data);
  }

  Future<ResBaseModel> updatePasswordFromProfile(
      ReqPasswordUpdateModel model) async {
    final response = await locator<ApiService>()
        .post(apiUpdatePassword, data: model.toJson());
    return ResBaseModel.fromJson(response?.data);
  }

  Future<ResProfileUpdateModel> updateProfile(
      ReqProfileUpdateModel model) async {
    final response = await locator<ApiService>()
        .post(apiUpdateProfile, data: model.toJson());
    return ResProfileUpdateModel.fromJson(response?.data);
  }

  Future<ResProfileUpdateModel> deleteProfile() async {
    final response = await locator<ApiService>().delete(apiDeleteProfile);
    return ResProfileUpdateModel.fromJson(response?.data);
  }

  Future<ResImageUploadModel> imageUpload(FormData formData) async {
    final response = await locator<ApiService>().multipartPost(
      apiMediaUpload,
      data: formData,
    );
    return ResImageUploadModel.fromJson(response!.data);
  }
}

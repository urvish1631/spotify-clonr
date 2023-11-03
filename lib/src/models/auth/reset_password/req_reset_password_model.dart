import 'package:json_annotation/json_annotation.dart';

part 'req_reset_password_model.g.dart';

@JsonSerializable()
class ReqResetPasswordModel {
  String? otp;
  String? confirmPassword;
  String? email;
  String? password;

  ReqResetPasswordModel({this.email, this.password, this.confirmPassword, this.otp});

  factory ReqResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ReqResetPasswordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqResetPasswordModelToJson(this);
}

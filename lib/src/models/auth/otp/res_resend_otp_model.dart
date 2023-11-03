import 'package:json_annotation/json_annotation.dart';

part 'res_resend_otp_model.g.dart';

@JsonSerializable()
class ResResendOtpModel {
  String? msg;
  @JsonKey(name: 'OTP')
  String? otp;

  ResResendOtpModel({this.msg, this.otp});

  factory ResResendOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ResResendOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResResendOtpModelToJson(this);
}

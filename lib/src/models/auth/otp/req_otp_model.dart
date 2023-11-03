import 'package:json_annotation/json_annotation.dart';

part 'req_otp_model.g.dart';

@JsonSerializable()
class ReqOtpModel {
  String? email;
  @JsonKey(name: 'OTP')
  String? otp;

  ReqOtpModel({this.email, this.otp});

  factory ReqOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ReqOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqOtpModelToJson(this);
}

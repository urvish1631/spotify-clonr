import 'package:json_annotation/json_annotation.dart';

part 'req_resend_otp_model.g.dart';

@JsonSerializable()
class ReqResendOtpModel {
  String? email;

  ReqResendOtpModel({this.email});

  factory ReqResendOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ReqResendOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqResendOtpModelToJson(this);
}

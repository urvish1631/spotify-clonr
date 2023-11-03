import 'package:json_annotation/json_annotation.dart';

part 'res_otp_model.g.dart';

@JsonSerializable()
class ResOtpModel {
  String? token;
  String? type;
  String? message;
  Data? data;

  ResOtpModel({this.message, this.token, this.data, this.type});

  factory ResOtpModel.fromJson(Map<String, dynamic> json) =>
      _$ResOtpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResOtpModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Data {
  int? userId;

  Data({this.userId});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

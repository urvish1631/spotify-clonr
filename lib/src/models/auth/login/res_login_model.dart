import 'package:json_annotation/json_annotation.dart';

part 'res_login_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResLoginModel {
  String? token;
  String? msg;
  User? user;

  ResLoginModel({this.token, this.user});

  factory ResLoginModel.fromJson(Map<String, dynamic> json) =>
      _$ResLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResLoginModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: 'OTP')
  String? otp;
  bool? isOtpVerified;
  String? languagePref;
  String? themePref;
  List<String>? permissions;
  bool? isActive;
  bool? isCreatorApproved;
  String? userType;
  String? updatedAt;
  String? createdAt;
  String? imageURL;

  User(
      {this.id,
      this.name,
      this.email,
      this.otp,
      this.isOtpVerified,
      this.languagePref,
      this.themePref,
      this.permissions,
      this.isActive,
      this.isCreatorApproved,
      this.userType,
      this.updatedAt,
      this.imageURL,
      this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'req_signup_model.g.dart';

@JsonSerializable()
class ReqSignUpModel {
  String? name;
  String? userType;
  String? mobile;
  String? email;
  String? password;

  ReqSignUpModel(
      {this.mobile, this.email, this.password, this.userType, this.name});

  factory ReqSignUpModel.fromJson(Map<String, dynamic> json) =>
      _$ReqSignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqSignUpModelToJson(this);
}

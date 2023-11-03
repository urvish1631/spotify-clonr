import 'package:json_annotation/json_annotation.dart';

part 'req_login_model.g.dart';

@JsonSerializable()
class ReqLoginModel {
  String? email;
  String? password;

  ReqLoginModel({this.email, this.password});

  factory ReqLoginModel.fromJson(Map<String, dynamic> json) =>
      _$ReqLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqLoginModelToJson(this);
}

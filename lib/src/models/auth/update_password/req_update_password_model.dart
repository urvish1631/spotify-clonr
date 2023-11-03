import 'package:json_annotation/json_annotation.dart';

part 'req_update_password_model.g.dart';

@JsonSerializable()
class ReqPasswordUpdateModel {
  String? newPassword;
  String? oldPassword;

  ReqPasswordUpdateModel({this.newPassword, this.oldPassword});

  factory ReqPasswordUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ReqPasswordUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqPasswordUpdateModelToJson(this);
}

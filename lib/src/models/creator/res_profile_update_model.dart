import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/auth/login/res_login_model.dart';

part 'res_profile_update_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResProfileUpdateModel {
  String? msg;
  User? data;

  ResProfileUpdateModel({this.data});

  factory ResProfileUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ResProfileUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResProfileUpdateModelToJson(this);
}

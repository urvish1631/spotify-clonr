import 'package:json_annotation/json_annotation.dart';
import 'package:sada_app/src/models/auth/login/res_login_model.dart';

part 'res_language_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResLanguageModel {
  User? user;

  ResLanguageModel({this.user});

  factory ResLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$ResLanguageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResLanguageModelToJson(this);
}

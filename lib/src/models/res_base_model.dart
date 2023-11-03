import 'package:json_annotation/json_annotation.dart';

part 'res_base_model.g.dart';

@JsonSerializable()
class ResBaseModel {
  String? error;
  String? msg;

  ResBaseModel({this.error, this.msg});

  factory ResBaseModel.fromJson(Map<String, dynamic> json) =>
      _$ResBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResBaseModelToJson(this);
}

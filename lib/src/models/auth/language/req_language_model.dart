import 'package:json_annotation/json_annotation.dart';

part 'req_language_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReqLanguageModel {
  String? languagePref;

  ReqLanguageModel({this.languagePref});

  factory ReqLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$ReqLanguageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqLanguageModelToJson(this);
}

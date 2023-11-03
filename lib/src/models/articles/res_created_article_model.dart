import 'package:json_annotation/json_annotation.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';

part 'res_created_article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResCreatedArticleModel {
  String? msg;
  Article? data;

  ResCreatedArticleModel({this.msg, this.data});

  factory ResCreatedArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ResCreatedArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCreatedArticleModelToJson(this);
}

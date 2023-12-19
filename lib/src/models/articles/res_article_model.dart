import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';

part 'res_article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResArticlesModel {
  List<Article>? data;
  int? count;
  int? limit;

  ResArticlesModel({
    this.data,
    this.count,
    this.limit,
  });

  factory ResArticlesModel.fromJson(Map<String, dynamic> json) =>
      _$ResArticlesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResArticlesModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';

part 'res_recently_played_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResRecentlyPlayedModel {
  List<RecentlyPlayedArticleModel>? data;

  ResRecentlyPlayedModel({this.data});

  factory ResRecentlyPlayedModel.fromJson(Map<String, dynamic> json) =>
      _$ResRecentlyPlayedModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResRecentlyPlayedModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecentlyPlayedArticleModel {
  int? id;
  int? articleId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  Article? article;

  RecentlyPlayedArticleModel({
    this.id,
    this.article,
    this.createdAt,
    this.updatedAt,
    this.articleId,
    this.userId,
  });

  factory RecentlyPlayedArticleModel.fromJson(Map<String, dynamic> json) =>
      _$RecentlyPlayedArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentlyPlayedArticleModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';

part 'res_category_wise_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResCategoryWiseModel {
  List<Article>? data;
  int? count;
  int? limit;

  ResCategoryWiseModel({
    this.data,
    this.count,
    this.limit,
  });

  factory ResCategoryWiseModel.fromJson(Map<String, dynamic> json) =>
      _$ResCategoryWiseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCategoryWiseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SingleCategory {
  int? id;
  int? articleId;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  Article? article;

  SingleCategory({
    this.id,
    this.articleId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.article,
  });

  factory SingleCategory.fromJson(Map<String, dynamic> json) =>
      _$SingleCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SingleCategoryToJson(this);
}

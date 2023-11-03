import 'package:json_annotation/json_annotation.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';

part 'res_get_article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResSingleArticlesModel {
  Article? data;

  ResSingleArticlesModel({
    this.data,
  });

  factory ResSingleArticlesModel.fromJson(Map<String, dynamic> json) =>
      _$ResSingleArticlesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResSingleArticlesModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetCategories {
  int? categoryId;

  GetCategories({
    this.categoryId,
  });

  factory GetCategories.fromJson(Map<String, dynamic> json) =>
      _$GetCategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$GetCategoriesToJson(this);
}

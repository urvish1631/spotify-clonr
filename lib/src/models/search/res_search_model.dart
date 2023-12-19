import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/models/category/res_category_model.dart';

part 'res_search_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResSearchModel {
  List<CategoryModel>? categories;
  List<Article>? articles;
  List<CategoryModel>? creators;

  ResSearchModel({
    this.creators,
    this.categories,
    this.articles,
  });

  factory ResSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ResSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResSearchModelToJson(this);
}

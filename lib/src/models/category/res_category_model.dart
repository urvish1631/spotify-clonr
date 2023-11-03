import 'package:json_annotation/json_annotation.dart';

part 'res_category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResCategoriesModel {
  List<CategoryModel>? data;
  int? count;
  int? limit;

  ResCategoriesModel({this.data, this.count, this.limit});

  factory ResCategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$ResCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCategoriesModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryModel {
  int? id;
  String? name;
  String? imageURL;
  int? isFollowed;

  CategoryModel({this.id, this.name, this.isFollowed, this.imageURL});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

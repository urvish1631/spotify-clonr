import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/articles/res_get_article_model.dart';

part 'res_recommendation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResRecommendationModel {
  List<Article>? data;
  int? limit;
  int? count;

  ResRecommendationModel({this.data, this.count, this.limit});

  factory ResRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$ResRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResRecommendationModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Article {
  int? id;
  User? user;
  String? title;
  String? imageURL;
  String? articleType;
  int? isActive;
  String? recordedFile;
  String? writtenText;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? isLiked;
  Article? article;
  List<GetCategories>? articleCategories;

  Article({
    this.id,
    this.user,
    this.title,
    this.imageURL,
    this.articleType,
    this.isActive,
    this.recordedFile,
    this.userId,
    this.article,
    this.createdAt,
    this.writtenText,
    this.isLiked,
    this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User {
  int? id;
  String? name;
  String? imageURL;

  User({this.id, this.name, this.imageURL});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ArticleModel {
  int? id;
  String? title;
  String? imageURL;
  User? user;

  ArticleModel({
    this.id,
    this.title,
    this.imageURL,
    this.user,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

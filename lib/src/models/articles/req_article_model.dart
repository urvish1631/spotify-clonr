import 'package:json_annotation/json_annotation.dart';

part 'req_article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReqArticleModel {
  String? title;
  String? imageURL;
  String? articleType;
  String? recordedFile;
  String? writtenText;
  List<String>? categories;

  ReqArticleModel({
    this.title,
    this.imageURL,
    this.articleType,
    this.recordedFile,
    this.categories,
    this.writtenText,
  });

  factory ReqArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ReqArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqArticleModelToJson(this);
}

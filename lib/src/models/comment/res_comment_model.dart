import 'package:json_annotation/json_annotation.dart';
import 'package:sada_app/src/models/articles/res_recommendation_model.dart';

part 'res_comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResCommentSectionModel {
  List<CommentModel>? data;
  int? count;
  int? limit;
  String? msg;

  ResCommentSectionModel({this.data, this.count, this.limit, this.msg});

  factory ResCommentSectionModel.fromJson(Map<String, dynamic> json) =>
      _$ResCommentSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCommentSectionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CommentModel {
  int? id;
  int? userId;
  int? articleId;
  String? commentFile;
  String? updatedAt;
  String? createdAt;
  User? user;

  CommentModel(
      {this.id,
      this.userId,
      this.articleId,
      this.commentFile,
      this.updatedAt,
      this.user,
      this.createdAt});

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ResCreatedCommentModel {
  CommentModel? data;
  String? msg;

  ResCreatedCommentModel({this.data, this.msg});

  factory ResCreatedCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ResCreatedCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCreatedCommentModelToJson(this);
}

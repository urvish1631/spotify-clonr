import 'package:json_annotation/json_annotation.dart';

part 'req_comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReqCommentSectionModel {
  String? commentFile;

  ReqCommentSectionModel({this.commentFile});

  factory ReqCommentSectionModel.fromJson(Map<String, dynamic> json) =>
      _$ReqCommentSectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqCommentSectionModelToJson(this);
}
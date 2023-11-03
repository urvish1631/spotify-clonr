import 'package:json_annotation/json_annotation.dart';

part 'req_recommendation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReqRecommendationModel {
  List<int>? previousArticles;

  ReqRecommendationModel({this.previousArticles});

  factory ReqRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$ReqRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqRecommendationModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:spotify_clone/src/models/articles/res_recommendation_model.dart';
import 'package:spotify_clone/src/models/user/res_user_profile_model.dart';

part 'res_creator_profile_model.g.dart';

@JsonSerializable()
class ResCreatorProfileModel {
  CreatorProfile? creatorProfile;

  ResCreatorProfileModel({this.creatorProfile});

  factory ResCreatorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ResCreatorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResCreatorProfileModelToJson(this);
}

@JsonSerializable()
class CreatorProfile {
  UserProfileData? creator;
  List<Article>? articles;
  int? articleCount;
  int? followerCount;

  CreatorProfile({this.articles, this.articleCount, this.followerCount});

  factory CreatorProfile.fromJson(Map<String, dynamic> json) =>
      _$CreatorProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorProfileToJson(this);
}

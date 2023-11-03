import 'package:json_annotation/json_annotation.dart';

part 'res_user_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResUserProfileModel {
  UserProfile? userProfile;

  ResUserProfileModel({this.userProfile});

  factory ResUserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ResUserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResUserProfileModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserProfile {
  UserProfileData? user;
  int? followingCount;

  UserProfile({this.user, this.followingCount});

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserProfileData {
  int? id;
  String? name;
  String? imageURL;
  String? email;

  UserProfileData({this.id, this.name, this.imageURL, this.email});

  factory UserProfileData.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileDataToJson(this);
}

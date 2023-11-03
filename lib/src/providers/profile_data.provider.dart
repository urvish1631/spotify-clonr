import 'package:flutter/material.dart';
import 'package:sada_app/src/models/auth/login/res_login_model.dart';
import 'package:sada_app/src/models/creator/res_creator_profile_model.dart';
import 'package:sada_app/src/models/user/res_user_profile_model.dart';

class ProfileDataProvider extends ChangeNotifier {
  ResCreatorProfileModel? _creatorData;
  ResCreatorProfileModel? _artistProfileData;
  ResUserProfileModel? _userProfileData;

  User? _profileData;

  ResCreatorProfileModel? get creatorData {
    return _creatorData;
  }

  ResCreatorProfileModel? get artistProfileData {
    return _artistProfileData;
  }

  ResUserProfileModel? get userProfileData {
    return _userProfileData;
  }

  User? get profileData {
    return _profileData;
  }

  bool _isApiCalled = false;

  bool get isApiCalled => _isApiCalled;

  setApiFalse() {
    _isApiCalled = false;
    notifyListeners();
  }

  void addCreatorProfileData(ResCreatorProfileModel? creatorData) {
    _creatorData = creatorData;
    _isApiCalled = true;
    notifyListeners();
  }

  void addProfileData(User? data) {
    _profileData = data;
    _isApiCalled = true;
    notifyListeners();
  }

  void addUserProfile(ResUserProfileModel? userProfileData) {
    _userProfileData = userProfileData;
    _isApiCalled = true;
    notifyListeners();
  }

  void addArtistProfileData(ResCreatorProfileModel? artistProfileData) {
    _artistProfileData = artistProfileData;
    _isApiCalled = true;
    notifyListeners();
  }

  followedArtist(bool isFollowed) {
    if (isFollowed) {
      int? count = artistProfileData?.creatorProfile?.followerCount;
      artistProfileData?.creatorProfile?.followerCount = (count ?? 0) - 1;
    } else {
      int? count = artistProfileData?.creatorProfile?.followerCount;
      artistProfileData?.creatorProfile?.followerCount = (count ?? 0) + 1;
    }
    notifyListeners();
  }

  clearData() {
    _isApiCalled = false;
    notifyListeners();
  }
}

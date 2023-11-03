import 'package:json_annotation/json_annotation.dart';

part 'res_playlist_model.g.dart';

@JsonSerializable()
class ResPlaylistModel {
  String? msg;
  PlaylistModel? data;

  ResPlaylistModel({this.msg, this.data});

  factory ResPlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$ResPlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResPlaylistModelToJson(this);
}

@JsonSerializable()
class ResGetPlaylistModel {
  int? limit;
  List<PlaylistModel>? data;
  int? count;

  ResGetPlaylistModel({this.limit,this.count, this.data});

  factory ResGetPlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$ResGetPlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResGetPlaylistModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlaylistModel {
  int? id;
  int? userId;
  String? name;
  String? imageURL;
  String? updatedAt;
  String? createdAt;

  PlaylistModel(
      {this.id,
      this.userId,
      this.name,
      this.imageURL,
      this.updatedAt,
      this.createdAt});

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistModelToJson(this);
}


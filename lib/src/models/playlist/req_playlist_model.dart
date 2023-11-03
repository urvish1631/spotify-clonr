import 'package:json_annotation/json_annotation.dart';

part 'req_playlist_model.g.dart';

@JsonSerializable()
class ReqPlaylistModel {
  String? name;
  String? imageURL;

  ReqPlaylistModel({this.name, this.imageURL});

  factory ReqPlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$ReqPlaylistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqPlaylistModelToJson(this);
}

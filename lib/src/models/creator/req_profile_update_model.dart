import 'package:json_annotation/json_annotation.dart';

part 'req_profile_update_model.g.dart';

@JsonSerializable()
class ReqProfileUpdateModel {
  String? name;
  String? imageURL;

  ReqProfileUpdateModel({
    this.name,
    this.imageURL,
  });

  factory ReqProfileUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$ReqProfileUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReqProfileUpdateModelToJson(this);
}

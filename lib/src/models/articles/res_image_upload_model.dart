import 'package:json_annotation/json_annotation.dart';

part 'res_image_upload_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResImageUploadModel {
  String? data;

  ResImageUploadModel({
    this.data,
  });

  factory ResImageUploadModel.fromJson(Map<String, dynamic> json) =>
      _$ResImageUploadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResImageUploadModelToJson(this);
}

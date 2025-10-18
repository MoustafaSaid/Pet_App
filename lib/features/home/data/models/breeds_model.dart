// import 'package:json_annotation/json_annotation.dart';
// import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';

// part 'breeds_model.g.dart';

// @JsonSerializable()
// class BreedsModel extends BreedsEntity {
//   final List<BreedModel> breeds;

//   const BreedsModel({required this.breeds}) : super(breeds: breeds);
//   factory BreedsModel.fromJson(Map<String, dynamic> json) =>
//       _$BreedsModelFromJson(json);

//   Map<String, dynamic> toJson() => _$BreedsModelToJson(this);
// }

// @JsonSerializable()
// class BreedModel extends BreedEntity {
//   @JsonKey(name: 'name')
//   final String breadsName;
//   @JsonKey(name: 'wikipedia_url')
//   final String wikipidiaUrl;
//   @JsonKey(name: 'reference_image_id')
//   final String refImageId;
//   @JsonKey(name: 'description')
//   final String description;
//   const BreedModel({
//     required this.breadsName,
//     required this.wikipidiaUrl,
//     required this.refImageId,
//     required this.description,
//   }) : super(
//          breadsName: breadsName,
//          wikipidiaUrl: wikipidiaUrl,
//          refImageId: refImageId,
//          description: description,
//        );
//   factory BreedModel.fromJson(Map<String, dynamic> json) =>
//       _$BreedModelFromJson(json);

//   Map<String, dynamic> toJson() => _$BreedModelToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';

part 'breeds_model.g.dart';

@JsonSerializable()
class BreedsModel extends BreedsEntity {
  final List<BreedModel> breeds;

  const BreedsModel({required this.breeds}) : super(breeds: breeds);

  /// ✅ Custom factory to handle top-level array
  factory BreedsModel.fromJsonList(List<dynamic> jsonList) {
    return BreedsModel(
      breeds: jsonList.map((e) => BreedModel.fromJson(e)).toList(),
    );
  }

  factory BreedsModel.fromJson(Map<String, dynamic> json) =>
      _$BreedsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedsModelToJson(this);
}

@JsonSerializable()
class BreedModel extends BreedEntity {
  @JsonKey(name: 'name')
  final String breadsName;

  @JsonKey(name: 'wikipedia_url')
  final String wikipidiaUrl;

  @JsonKey(name: 'reference_image_id')
  final String refImageId;

  @JsonKey(name: 'description')
  final String description;

  const BreedModel({
    required this.breadsName,
    required this.wikipidiaUrl,
    required this.refImageId,
    required this.description,
  }) : super(
         breadsName: breadsName,
         wikipidiaUrl: wikipidiaUrl,
         refImageId: refImageId,
         description: description,
       );

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedModelToJson(this);
}

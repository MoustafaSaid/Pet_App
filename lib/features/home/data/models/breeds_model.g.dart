// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeds_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedsModel _$BreedsModelFromJson(Map<String, dynamic> json) => BreedsModel(
  breeds: (json['breeds'] as List<dynamic>)
      .map((e) => BreedModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BreedsModelToJson(BreedsModel instance) =>
    <String, dynamic>{
      'breeds': instance.breeds.map((e) => e.toJson()).toList(),
    };

BreedModel _$BreedModelFromJson(Map<String, dynamic> json) => BreedModel(
  breadsName: json['name'] as String,
  wikipidiaUrl: json['wikipedia_url'] as String,
  refImageId: json['reference_image_id'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$BreedModelToJson(BreedModel instance) =>
    <String, dynamic>{
      'name': instance.breadsName,
      'wikipedia_url': instance.wikipidiaUrl,
      'reference_image_id': instance.refImageId,
      'description': instance.description,
    };

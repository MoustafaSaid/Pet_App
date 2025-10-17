import 'package:equatable/equatable.dart';

class BreedsEntity extends Equatable {
  final List<BreedEntity> breeds;
  const BreedsEntity({required this.breeds});
  @override
  List<Object?> get props => [breeds];
}

class BreedEntity extends Equatable {
  final String breadsName;
  final String wikipidiaUrl;
  final String refImageId;
  final String description;

  const BreedEntity({
    required this.breadsName,
    required this.wikipidiaUrl,
    required this.refImageId,
    required this.description,
  });

  @override
  List<Object?> get props => [
    breadsName,
    wikipidiaUrl,
    refImageId,
    description,
  ];
}

import 'package:equatable/equatable.dart';

class BreedsEntity extends Equatable {
  final String breadsName;
  final String wigipidiaUrl;
  final String refImageId;
  final String description;

  const BreedsEntity({
    required this.breadsName,
    required this.wigipidiaUrl,
    required this.refImageId,
    required this.description,
  });

  @override
  List<Object?> get props => [
    breadsName,
    wigipidiaUrl,
    refImageId,
    description,
  ];
}

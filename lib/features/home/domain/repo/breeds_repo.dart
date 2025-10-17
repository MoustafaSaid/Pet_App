import 'package:dartz/dartz.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';

abstract class BreedsRepo {
  Future<Either<Failure, List<BreedsEntity>>> getBreeds({
    required int page,
    required int limit,
  });
}

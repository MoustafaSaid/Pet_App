import 'package:dartz/dartz.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';
import 'package:pet_app/features/home/domain/repo/breeds_repo.dart';

class GetBreedsUseCase {
  GetBreedsUseCase(this.repo);
  final BreedsRepo repo;
  Future<Either<Failure, List<BreedsEntity>>> call({
    required int page,
    required int limit,
  }) async => await repo.getBreeds(page: page, limit: limit);
}

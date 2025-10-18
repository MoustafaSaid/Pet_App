import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/core/usecases/usecase.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';
import 'package:pet_app/features/home/domain/repo/breeds_repo.dart';

class GetBreedsUseCase implements BaseUseCase<List<BreedEntity>, Params> {
  GetBreedsUseCase(this.repo);
  final BreedsRepo repo;
  @override
  Future<Either<Failure, List<BreedEntity>>> call(Params params) async =>
      await repo.getBreeds(page: params.page, limit: params.limit);
}

class Params extends Equatable {
  final int page;
  final int limit;
  const Params({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}

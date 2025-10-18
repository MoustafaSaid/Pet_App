import 'package:dartz/dartz.dart';
import 'package:pet_app/core/error/failures.dart';

abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}

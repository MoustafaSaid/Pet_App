import 'package:dartz/dartz.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/core/platform/network_info.dart';
import 'package:pet_app/features/home/data/data_source/breeds_locale_data_source.dart';
import 'package:pet_app/features/home/data/data_source/breeds_remote_data_source.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';
import 'package:pet_app/features/home/domain/repo/breeds_repo.dart';

class BreedsRepoImpl implements BreedsRepo {
  final BreedsRemoteDataSource remoteDataSource;
  final BreedsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BreedsRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, BreedsEntity>> getBreeds({
    required int page,
    required int limit,
  }) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      // Will complete in later tests
      try {
        final remoteBreeds = await remoteDataSource.getBreeds(
          page: page,
          limit: limit,
        );
        await localDataSource.cacheBreeds(remoteBreeds);
        return Right(remoteBreeds);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localBreeds = await localDataSource.getCachedBreeds();
        return Right(localBreeds);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}

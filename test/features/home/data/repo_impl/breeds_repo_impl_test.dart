import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_app/core/error/exceptions.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/core/network/network_info.dart';
import 'package:pet_app/features/home/data/data_source/breeds_locale_data_source.dart';
import 'package:pet_app/features/home/data/data_source/breeds_remote_data_source.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';
import 'package:pet_app/features/home/data/repo_impl/breeds_repo_impl.dart';

import 'breeds_repo_impl_test.mocks.dart';

// class MockBreedsRemoteDataSource extends Mock
//     implements BreedsRemoteDataSource {}

// class MockBreedsLocalDataSource extends Mock implements BreedsLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}
@GenerateMocks([NetworkInfo])
@GenerateMocks([BreedsRemoteDataSource, BreedsLocalDataSource])
void main() {
  late BreedsRepoImpl repo;
  late MockBreedsRemoteDataSource mockRemoteDataSource;
  late MockBreedsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  // late BreedsLocalDataSourceImpl dataSource;
  // late HiveInterface hive;

  setUp(() {
    // hive = Hive;
    // dataSource = BreedsLocalDataSourceImpl(hive);
    mockRemoteDataSource = MockBreedsRemoteDataSource();
    mockLocalDataSource = MockBreedsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repo = BreedsRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group("getBreeds", () {
    final tBreeds = List<BreedModel>.empty();
    test("should check if device is online", () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      await repo.getBreeds(page: 1, limit: 10);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test("should return remote data when device is online", () async {
        // arrange
        when(
          mockRemoteDataSource.getBreeds(page: 1, limit: 10),
        ).thenAnswer((_) async => tBreeds);
        // act
        final result = await repo.getBreeds(page: 1, limit: 10);
        // assert
        verify(mockRemoteDataSource.getBreeds(page: 1, limit: 10));
        expect(result, Right(tBreeds));
      });

      test("should cache the remote data when device is online", () async {
        // arrange
        when(
          mockRemoteDataSource.getBreeds(page: 1, limit: 10),
        ).thenAnswer((_) async => tBreeds);
        // act
        final result = await repo.getBreeds(page: 1, limit: 10);
        // assert
        verify(mockRemoteDataSource.getBreeds(page: 1, limit: 10));
        verify(mockLocalDataSource.cacheBreeds(tBreeds));
      });

      test(
        "should return server failure when the call to remote data source is unsuccessful",
        () async {
          // arrange
          when(
            mockRemoteDataSource.getBreeds(page: 1, limit: 10),
          ).thenThrow(ServerException());
          // act
          final result = await repo.getBreeds(page: 1, limit: 10);
          // assert
          verify(mockRemoteDataSource.getBreeds(page: 1, limit: 10));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        },
      );
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        "should return local data when device is offline with last cached data",
        () async {
          // arrange
          when(
            mockLocalDataSource.getCachedBreeds(),
          ).thenAnswer((_) async => tBreeds);
          // act
          final result = await repo.getBreeds(page: 1, limit: 10);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCachedBreeds());
          expect(result, Right(tBreeds));
        },
      );

      test("should return CacheFailure when there is no cached data", () async {
        // arrange
        when(mockLocalDataSource.getCachedBreeds()).thenThrow(CacheException());
        // act
        final result = await repo.getBreeds(page: 1, limit: 10);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedBreeds());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}

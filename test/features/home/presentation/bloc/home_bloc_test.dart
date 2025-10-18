import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:pet_app/core/error/failures.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';
import 'package:pet_app/features/home/domain/use_cases/get_breeds.dart';
import 'package:pet_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:pet_app/features/home/presentation/bloc/home_events.dart';
import 'package:pet_app/features/home/presentation/bloc/home_states.dart';

// This will generate the mock class
@GenerateMocks([GetBreedsUseCase])
import 'home_bloc_test.mocks.dart';

void main() {
  late HomeBloc homeBloc;
  late MockGetBreedsUseCase mockGetBreedsUseCase;

  setUp(() {
    mockGetBreedsUseCase = MockGetBreedsUseCase();
    homeBloc = HomeBloc(getBreedsUseCase: mockGetBreedsUseCase);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
    test('initial state should be HomeStatus.initial', () {
      expect(homeBloc.state.status, HomeStatus.initial);
    });

    test(
      'should emit [loading, loaded] when GetBreedsEvent is successful',
      () async {
        // Arrange
        final mockBreeds =
            <BreedEntity>[]; // Replace with your actual breed model list
        when(
          mockGetBreedsUseCase(any),
        ).thenAnswer((_) async => Right(mockBreeds));

        // Assert later
        final expected = [
          HomeStates(status: HomeStatus.loading),
          HomeStates(status: HomeStatus.loaded, breeds: mockBreeds),
        ];

        expectLater(homeBloc.stream, emitsInOrder(expected));

        // Act
        homeBloc.add(GetBreedsEvent(page: 1, limit: 10));
      },
    );

    test('should emit [loading, error] when GetBreedsEvent fails', () async {
      // Arrange
      final failure = ServerFailure();
      when(mockGetBreedsUseCase(any)).thenAnswer((_) async => Left(failure));

      // Assert later
      final expected = [
        HomeStates(status: HomeStatus.loading),
        HomeStates(status: HomeStatus.error, errorMessage: failure.toString()),
      ];

      expectLater(homeBloc.stream, emitsInOrder(expected));

      // Act
      homeBloc.add(GetBreedsEvent(page: 1, limit: 10));
    });

    test('should call GetBreedsUseCase with correct params', () async {
      // Arrange
      final page = 1;
      final limit = 10;
      final mockBreeds = <BreedEntity>[];
      when(
        mockGetBreedsUseCase(any),
      ).thenAnswer((_) async => Right(mockBreeds));

      // Act
      homeBloc.add(GetBreedsEvent(page: page, limit: limit));
      await untilCalled(mockGetBreedsUseCase(any));

      // Assert
      verify(mockGetBreedsUseCase(Params(page: page, limit: limit))).called(1);
    });

    test('should handle multiple GetBreedsEvent calls', () async {
      // Arrange
      final mockBreeds = <BreedEntity>[];
      when(
        mockGetBreedsUseCase(any),
      ).thenAnswer((_) async => Right(mockBreeds));

      // Act
      homeBloc.add(GetBreedsEvent(page: 1, limit: 10));
      await Future.delayed(Duration(milliseconds: 100));
      homeBloc.add(GetBreedsEvent(page: 2, limit: 10));

      // Assert
      await untilCalled(mockGetBreedsUseCase(any));
      verify(mockGetBreedsUseCase(any)).called(2);
    });
  });
}

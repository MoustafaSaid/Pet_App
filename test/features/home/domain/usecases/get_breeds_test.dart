import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';
import 'package:pet_app/features/home/domain/repo/breeds_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_app/features/home/domain/use_cases/get_breeds.dart';

// class MockBreedsRepo extends Mock implements BreedsRepo {}
//
@GenerateMocks([BreedsRepo])
import 'get_breeds_test.mocks.dart';

void main() {
  late GetBreedsUseCase getBreedsUseCase;
  late MockBreedsRepo mockBreedsRepo;
  setUp(() {
    mockBreedsRepo = MockBreedsRepo();
    getBreedsUseCase = GetBreedsUseCase(mockBreedsRepo);
  });
  final tBreed = BreedEntity(
    breadsName: 'Test',
    wikipidiaUrl: 'test',
    refImageId: 'test',
    description: 'test',
  );
  // final tBreeds = BreedsEntity(breeds: [tBreed, tBreed]);
  final tBreeds = [tBreed, tBreed];

  final int tPage = 1;
  final int tLimit = 10;
  test('should get breeds from repo', () async {
    //arrange
    when(
      mockBreedsRepo.getBreeds(page: 1, limit: 10),
    ).thenAnswer((_) async => Right(tBreeds));

    //act
    final result = await getBreedsUseCase(Params(page: tPage, limit: tLimit));

    //assert
    expect(result, Right(tBreeds));
    verify(mockBreedsRepo.getBreeds(page: tPage, limit: tLimit));
    verifyNoMoreInteractions(mockBreedsRepo);
  });
}

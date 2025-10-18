import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_app/features/home/data/data_source/breeds_remote_data_source.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';
import 'package:dio/dio.dart';

import '../repo_impl/breeds_repo_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BreedsRemoteDataSource>()])
void main() {
  late MockBreedsRemoteDataSource mockRemoteDataSource;

  late Dio dio;
  late BreedsRemoteDataSource dataSource;

  setUp(() {
    mockRemoteDataSource = MockBreedsRemoteDataSource();

    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.thecatapi.com/v1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dataSource = BreedsRemoteDataSource(dio);
  });
  test('should call getBreeds API with correct params', () async {
    // arrange
    final tBreedsModel = List<BreedModel>.empty(); //[];
    when(
      mockRemoteDataSource.getBreeds(page: 1, limit: 10),
    ).thenAnswer((_) async => tBreedsModel);

    // act
    final result = await mockRemoteDataSource.getBreeds(page: 1, limit: 10);

    // assert
    verify(mockRemoteDataSource.getBreeds(page: 1, limit: 10));
    expect(result, tBreedsModel);
  });
  test('should fetch real breeds data successfully', () async {
    final result = await dataSource.getBreeds(page: 1, limit: 5);

    // ✅ Because the API returns a list
    expect(result, isA<List<BreedModel>>());
    expect(result.isNotEmpty, true);

    print('✅ First breed: ${result.first.breadsName}');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_app/features/home/data/data_source/breeds_locale_data_source.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';

import 'breeds_locale_data_source_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late BreedsLocalDataSourceImpl dataSource;
  late MockHiveInterface mockHiveInterface;
  late MockBox mockBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockBox = MockBox();
    dataSource = BreedsLocalDataSourceImpl(mockHiveInterface);
  });

  group('getCachedBreeds', () {
    test('should return BreedsModel when cache exists', () async {
      // arrange
      final jsonData = List<BreedModel>.empty();

      when(
        mockHiveInterface.openBox(kBreedsBox),
      ).thenAnswer((_) async => mockBox);
      when(mockBox.get('breeds', defaultValue: [])).thenReturn(jsonData);

      // act
      final result = await dataSource.getCachedBreeds();

      // assert
      expect(result, isA<List<BreedModel>>());
      verify(mockHiveInterface.openBox(kBreedsBox));
      verify(mockBox.get('breeds', defaultValue: []));
    });

    test('should return empty BreedsModel when no cache exists', () async {
      when(
        mockHiveInterface.openBox(kBreedsBox),
      ).thenAnswer((_) async => mockBox);
      when(mockBox.get('breeds', defaultValue: [])).thenReturn([]);

      final result = await dataSource.getCachedBreeds();

      expect(result, isEmpty);
    });
  });

  group('cacheBreeds', () {
    test('should store BreedsModel in Hive', () async {
      final tModel = [
        BreedModel(
          breadsName: 'test',
          wikipidiaUrl: 'test',
          refImageId: 'test',
          description: 'test',
        ),
      ];

      when(
        mockHiveInterface.openBox(kBreedsBox),
      ).thenAnswer((_) async => mockBox);

      await dataSource.cacheBreeds(tModel);

      verify(mockHiveInterface.openBox(kBreedsBox));
      verify(mockBox.put('breeds', tModel));
    });
  });

  group('clearCache', () {
    test('should clear the Hive box', () async {
      // arrange
      when(
        mockHiveInterface.openBox(kBreedsBox),
      ).thenAnswer((_) async => mockBox);
      when(mockBox.clear()).thenAnswer((_) async => 0); // ✅ Stub added

      // act
      await dataSource.clearCache();

      // assert
      verify(mockHiveInterface.openBox(kBreedsBox));
      verify(mockBox.clear());
    });
  });
}

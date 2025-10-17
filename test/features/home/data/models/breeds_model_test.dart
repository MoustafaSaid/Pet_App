import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';
import 'package:pet_app/features/home/domain/entity/breeds_entity.dart';

import '../../../../fixtures/fixtrures_reader.dart';

void main() {
  final tBreedModel = BreedModel(
    breadsName: 'test',
    wikipidiaUrl: 'test',
    refImageId: 'test',
    description: 'test',
  );

  final tBreedsModel = BreedsModel(breeds: [tBreedModel, tBreedModel]);
  test("should be subclass of Breeds entity", () async {
    expect(tBreedsModel, isA<BreedsEntity>());
  });

  /// this [first Implementation] is not working
  // group('fromJson', () {
  //   test('should return a valid model', () async {
  //     // final result = BreedsModel.fromJson(fixture('breeds.json'));
  //     // expect(result, tBreedsModel);
  //     final List<dynamic> jsonList =
  //         json.decode(fixture('breeds.json')) as Map<String, dynamic>;
  //     final result = BreedsModel.fromJson(jsonMap);
  //     expect(result, tBreedsModel);
  //   });
  // });
  /// this [second Implementation] is working
  group('fromJson', () {
    test('should return a valid model', () async {
      final List<dynamic> jsonList =
          json.decode(fixture('breeds.json')) as List<dynamic>;

      final result = BreedsModel.fromJsonList(jsonList);
      //comment when matching the result with the tBreedsModel i have to take in my account the data has
      //
      // to be the same value so if it has 2 items the json has to have 2 items if the name == text thejson also has name ==test
      // expect(result.breeds.first.breadsName, equals('Abyssinian'));
      // expect(result.breeds.length, greaterThan(1));
      expect(result, tBreedsModel);
    });
  });
}

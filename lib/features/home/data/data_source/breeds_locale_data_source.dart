import 'package:hive_ce/hive.dart';
import 'package:pet_app/features/home/data/models/breeds_model.dart';

abstract class BreedsLocalDataSource {
  Future<void> cacheBreeds(BreedsModel breeds);
  Future<BreedsModel> getCachedBreeds();
  Future<void> clearCache();
}

const String kBreedsBox = 'breedsBox';

class BreedsLocalDataSourceImpl implements BreedsLocalDataSource {
  final HiveInterface hive;

  BreedsLocalDataSourceImpl(this.hive);

  @override
  Future<void> cacheBreeds(BreedsModel breeds) async {
    final box = await hive.openBox(kBreedsBox);
    // Store as list of JSON
    // final jsonList = breeds((breed) => breed.toJson()).toList();
    await box.put('breeds', breeds);
  }

  @override
  Future<BreedsModel> getCachedBreeds() async {
    final box = await hive.openBox(kBreedsBox);
    final jsonList = box.get('breeds', defaultValue: []);
    if (jsonList == null || jsonList.isEmpty) {
      return BreedsModel(breeds: []);
    }
    return BreedsModel.fromJson(jsonList);
  }

  @override
  Future<void> clearCache() async {
    final box = await hive.openBox(kBreedsBox);
    await box.clear();
  }
}

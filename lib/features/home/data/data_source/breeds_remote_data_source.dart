import 'package:pet_app/features/home/data/models/breeds_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'breeds_remote_data_source.g.dart';

@RestApi(baseUrl: 'https://api.thecatapi.com/v1/')
abstract class BreedsRemoteDataSource {
  factory BreedsRemoteDataSource(Dio dio) = _BreedsRemoteDataSource;
  @GET('breeds')
  Future<BreedsModel> getBreeds({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });
}

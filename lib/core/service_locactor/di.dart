import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pet_app/core/network/network_info.dart';
import 'package:pet_app/features/home/data/data_source/breeds_locale_data_source.dart';
import 'package:pet_app/features/home/data/data_source/breeds_remote_data_source.dart';
import 'package:pet_app/features/home/data/repo_impl/breeds_repo_impl.dart';
import 'package:pet_app/features/home/domain/repo/breeds_repo.dart';
import 'package:pet_app/features/home/domain/use_cases/get_breeds.dart';
import 'package:pet_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;
Future<void> init({required Box userPreferenceBox}) async {
  // Future<void> init() async {
  sl.registerLazySingleton(() => createAndSetupDio());
  sl.registerLazySingleton(() => userPreferenceBox);
  sl.registerLazySingleton<BreedsRemoteDataSource>(
    () => BreedsRemoteDataSource(createAndSetupDio()),
  );
  sl.registerLazySingleton<BreedsLocalDataSource>(
    () => BreedsLocalDataSourceImpl(sl()),
  );
  //need hive for locale data
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker.instance),
  );
  sl.registerLazySingleton<HiveInterface>(() => Hive);
  sl.registerFactory<HomeBloc>(() => HomeBloc(getBreedsUseCase: sl()));

  sl.registerLazySingleton<GetBreedsUseCase>(() => GetBreedsUseCase(sl()));
  sl.registerLazySingleton<BreedsRepo>(
    () => BreedsRepoImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // sl.registerLazySingleton<UserPreferenceSource>(() => UserPreferenceSource(
  // userPreferenceBox: userPreferenceBox,
  // ));
}

Dio createAndSetupDio() {
  Dio dio = Dio();
  dio.interceptors.addAll([AppendHeaderInterceptor()]);

  // dio
  // ..options.connectTimeout = const Duration(seconds: 5)
  // ..options.receiveTimeout = const Duration(seconds: 5);

  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
    ),
  );
  return dio;
}

class AppendHeaderInterceptor extends Interceptor {
  AppendHeaderInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    return super.onRequest(options, handler);
  }
}

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:mike_lima_clean_architecture/core/network/network_info.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/repositories/search_product_repository_impl.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/usecases/search_product.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/search_product/data/datasources/search_product_local_data_source.dart';
import 'features/search_product/data/datasources/search_product_remote_data_source.dart';
import 'features/search_product/domain/repositories/search_product_repository.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Mike Lima
  // - Bloc
  sl.registerFactory(
    () => ProductSearchBloc(
      searchProduct: sl(),
    ),
  );

  // - Register use cases
  sl.registerLazySingleton(() => SearchProduct(sl()));

  // - Repository
  sl.registerLazySingleton<SearchProductRepository>(
    () => SearchProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // - Data sources
  sl.registerLazySingleton<SearchProductRemoteDataSource>(
    () => SearchProductRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<SearchProductLocalDataSource>(
    () => SearchProductLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

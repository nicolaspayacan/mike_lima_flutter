import 'package:dartz/dartz.dart';
import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/core/network/network_info.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_local_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/repositories/search_product_repository.dart';
import 'package:meta/meta.dart';

class SearchProductRepositoryImpl implements SearchProductRepository {
  final SearchProductRemoteDataSource remoteDataSource;
  final SearchProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchProductRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductSearch>> searchProduct(String query) async {
    if (await networkInfo.isConnected) {
      try {
        var remoteSearch = await remoteDataSource.searchProduct(query);
        localDataSource.cacheProductSearch(remoteSearch);
        return Right(remoteSearch);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        var localSearch = await localDataSource.getLastSearch();
        return Right(localSearch);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

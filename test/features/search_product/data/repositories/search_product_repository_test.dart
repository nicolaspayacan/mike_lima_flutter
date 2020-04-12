import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/core/network/network_info.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_local_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/repositories/search_product_repository_impl.dart';

class MockRemoteDataSource extends Mock
    implements SearchProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements SearchProductLocalDataSource {
}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  SearchProductRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = SearchProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', ()
    {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group(
    'productSearch',
        () {
      final tSearchQuery = "foo";
      final tProductSearchModel = ProductSearchModel(
        site_id: "MLA",
        query: tSearchQuery,
        results: null,
      );
      final tProductSearch = tProductSearchModel;

      test(
        'should check if the device is online',
            () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          repository.searchProduct("foo");

          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(() {

        test(
          'should return remote data when the call to remote datasource is succesfull',
              () async {
            when(mockRemoteDataSource.searchProduct(any))
                .thenAnswer((_) async => tProductSearchModel);

            final result = await repository.searchProduct(tSearchQuery);

            verify(mockRemoteDataSource.searchProduct(tSearchQuery));
            expect(result, Right(tProductSearch));
          },
        );

        test(
          'should cache the data locally when the call to remote datasource is succesfull',
              () async {
            when(mockRemoteDataSource.searchProduct(any))
                .thenAnswer((_) async => tProductSearchModel);

            await repository.searchProduct(tSearchQuery);

            verify(mockRemoteDataSource.searchProduct(tSearchQuery));
            verify(
                mockLocalDataSource.cacheProductSearch(tProductSearchModel));
          },
        );

        test(
          'should return server failure when the call to remote datasource is unsuccesfull',
              () async {
            when(mockRemoteDataSource.searchProduct(any))
                .thenThrow(ServerException());

            final result = await repository.searchProduct(tSearchQuery);

            verify(mockRemoteDataSource.searchProduct(tSearchQuery));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, Left(ServerFailure()));
          },
        );
      });

      runTestOffline(() {
        test(
          'should return last searched products when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastSearch())
                .thenAnswer((_) async => tProductSearchModel);

            final result = await repository.searchProduct(tSearchQuery);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastSearch());
            expect(result, Right(tProductSearch));
          },
        );

        test(
          'should return cache failure when no cached data is present',
              () async {
            when(mockLocalDataSource.getLastSearch())
                .thenThrow(CacheException());

            final result = await repository.searchProduct(tSearchQuery);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastSearch());
            expect(result, Left(CacheFailure()));
          },
        );
      });
    },
  );
}

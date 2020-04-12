import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_model.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_local_data_source.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SearchProductLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SearchProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastProductSearch', () {
    final tProductSearchModel = ProductSearchModel.fromJson(
        json.decode(fixture('product_search_cached.json')));

    test(
      'should return ProductSearch from SharedPreferences when there is one in the cache',
      () async {
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('product_search_cached.json'));

        final result = await dataSource.getLastSearch();

        verify(mockSharedPreferences.getString(CACHED_PRODUCT_SEARCH_KEY));
        expect(result, equals(tProductSearchModel));
      },
    );

    test(
      'should throw cache exception when there is not a cached value',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final call = dataSource.getLastSearch;

        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheProductSearch', () {
    final tProductSearchModel = ProductSearchModel(
      site_id: "MLA",
      query: "foo",
      results: null,
    );
    test(
      'should call SharedPreferences to cache the data',
      () async {
        dataSource.cacheProductSearch(tProductSearchModel);

        final expectedJsonString = json.encode(tProductSearchModel.toJson());

        verify(mockSharedPreferences.setString(
            CACHED_PRODUCT_SEARCH_KEY, expectedJsonString));
      },
    );
  });

  group('getLastSearchQuery', () {
    String tQuerySearch = "remera";

    test(
      'should return las search query',
      () async {
        when(mockSharedPreferences.getString(any))
            .thenReturn(tQuerySearch = "remera");

        final result = await dataSource.getLastSearchQuery();

        verify(mockSharedPreferences.getString(CACHED_SEARCH_QUERY_KEY));
        expect(tQuerySearch, equals(result));
      },
    );

    test(
      'should cache exception when last search query is not found',
      () async {
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        final result = dataSource.getLastSearchQuery;

        expect(() => result(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheSearchQuery', () {
    String tQuerySearch = "remera";
    test(
      'should call SharedPreferences to cache the data',
          () async {
        dataSource.cacheSearchQuery(tQuerySearch);

        verify(mockSharedPreferences.setString(
            CACHED_SEARCH_QUERY_KEY, tQuerySearch));
      },
    );
  });
}

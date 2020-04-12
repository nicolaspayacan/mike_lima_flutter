import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  SearchProductRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = SearchProductRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('product_search_result.json'), 200));
  }

  void setUpMockHttpClientError404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('searchProduct', () {
    final tSearchQuery = "";
    final tProductSearchModel = ProductSearchModel.fromJson(
        json.decode(fixture('product_search_result.json')));

    test(
      '''should perform GET request on a URLL with search 
          query being the enddpoint and with application/json header''',
      () async {
        setUpMockHttpClientSuccess200();

        dataSource.searchProduct(tSearchQuery);

        verify(mockHttpClient.get(
          'https://api.mercadolibre.com/sites/MLA/search?q=$tSearchQuery',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return ProductSearchModel when the response code is 200',
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSource.searchProduct(tSearchQuery);

        expect(result, equals(tProductSearchModel));
      },
    );

    test(
      'should throw a ServerException when error code is not 200',
      () async {
        setUpMockHttpClientError404();

        final call = dataSource.searchProduct;

        expect(
            () => call(tSearchQuery), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}

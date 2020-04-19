import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/datasources/product_detail_remote_data_source.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_detail_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  ProductDetailRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ProductDetailRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  group('getProductDetail', () {
    final tProductId = "";
    final tProductDetailModel = ProductDetailModel.fromJson(
        json.decode(fixture('product_detail_result.json')));

    void setUpMockHttpClientSuccess200() {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(fixture('product_detail_result.json'), 200));
    }

    void setUpMockHttpClientError404() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
    }

    test(
      '''should perform GET request on a URL with productId 
          being the enddpoint and with application/json header''',
      () async {
        setUpMockHttpClientSuccess200();

        dataSource.getProductDetail(tProductId);

        verify(mockHttpClient.get(
          'https://api.mercadolibre.com/items?ids=$tProductId',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return ProductDetailModel when respose code is 200',
      () async {
        setUpMockHttpClientSuccess200();

        final result = await dataSource.getProductDetail(tProductId);

        expect(result, equals(tProductDetailModel));
      },
    );

    test(
      'should return ServerException when respose code is not 200',
      () async {
        setUpMockHttpClientError404();

        final call = dataSource.getProductDetail;

        expect(() => call(tProductId), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}

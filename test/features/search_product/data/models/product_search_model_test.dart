import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_model.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tProductSearchModel = ProductSearchModel(
    site_id: "MLA",
    query: "Motorola G6",
    results: [
      ProductModel(
          id: "MLA810645375",
          title: "Motorola G6 Plus 64 Gb Nimbus",
          price: 17999.0),
      ProductModel(
          id: "MLA805330648", title: "Motorola G6 32 Gb Plata", price: 14899.0),
    ],
  );

  test(
    'should be a subclass of SearchProduct entity',
    () async {
      // assert
      expect(tProductSearchModel, isA<ProductSearch>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON exits',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('product_search_result.json'));

        // act
        final result = ProductSearchModel.fromJson(jsonMap);

        // assert
        expect(result, equals(tProductSearchModel));
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tProductSearchModel.toJson();

        var expectedMap = {
          "site_id": "MLA",
          "query": "Motorola G6",
          "results": [
            {
              "id": "MLA810645375",
              "title": "Motorola G6 Plus 64 Gb Nimbus",
              "price": 17999,
            },
            {
              "id": "MLA805330648",
              "title": "Motorola G6 32 Gb Plata",
              "price": 14899,
            }
          ]
        };
        expect(result, expectedMap);
      },
    );
  });
}

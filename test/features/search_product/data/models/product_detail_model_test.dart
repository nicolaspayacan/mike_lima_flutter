import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_detail_model.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductDetail.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tProductDetailModel = ProductDetailModel(
      productId: "MLA844638227",
      siteId: "MLA",
      title: "Camiseta adidas Boca Juniors Titular 2020 Hombre Original",
      price: 4599,
      currencyId: "ARS",
      availableQuantity: 52);

  test(
    'should be a subclass of ProductDetail entity',
    () async {
      expect(tProductDetailModel, isA<ProductDetail>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when JSON exists',
      () async {
        final List<dynamic> jsonMap =
            json.decode(fixture('product_detail_result.json'));

        final result = ProductDetailModel.fromJson(jsonMap);

        expect(result, tProductDetailModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = tProductDetailModel.toJson();

        var expectedMap = {
          "id": "MLA844638227",
          "site_id": "MLA",
          "title": "Camiseta adidas Boca Juniors Titular 2020 Hombre Original",
          "price": 4599,
          "currency_id": "ARS",
          "available_quantity": 52,
        };

        expect(result, expectedMap);
      },
    );
  });

}

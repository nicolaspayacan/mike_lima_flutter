import 'dart:convert';

import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class ProductDetailRemoteDataSource {
  /// Calls https://api.mercadolibre.com/items?ids=$ITEM_ID1
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductDetailModel> getProductDetail(String productId);
}

class ProductDetailRemoteDataSourceImpl
    implements ProductDetailRemoteDataSource {
  final http.Client client;

  ProductDetailRemoteDataSourceImpl({@required this.client});

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    final response = await client.get(
      'https://api.mercadolibre.com/items?ids=$productId',
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200)
      return ProductDetailModel.fromJson(json.decode(response.body));
    else
      throw ServerException();
  }
}

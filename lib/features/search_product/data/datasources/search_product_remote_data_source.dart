import 'dart:convert';

import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class SearchProductRemoteDataSource {
  /// Calls the https://api.mercadolibre.com/sites/MLA/search?q={query} endpoint
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductSearchModel> searchProduct(String query);
}

class SearchProductRemoteDataSourceImpl
    implements SearchProductRemoteDataSource {
  final http.Client client;

  SearchProductRemoteDataSourceImpl({@required this.client});

  @override
  Future<ProductSearchModel> searchProduct(String query) async {
    final response = await client.get(
      'https://api.mercadolibre.com/sites/MLA/search?q=$query',
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ProductSearchModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

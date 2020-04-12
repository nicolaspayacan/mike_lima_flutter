import 'dart:convert';

import 'package:mike_lima_clean_architecture/core/error/exceptions.dart';
import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_search_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class SearchProductLocalDataSource {
  Future<ProductSearchModel> getLastSearch();

  Future<void> cacheProductSearch(ProductSearchModel productSearchModel);

  Future<String> getLastSearchQuery();

  Future<void> cacheSearchQuery(String query);
}

const CACHED_PRODUCT_SEARCH_KEY = 'CACHED_PRODUCT_SEARCH';
const CACHED_SEARCH_QUERY_KEY = "CACHED_SEARCH_QUERY_KEY";

class SearchProductLocalDataSourceImpl implements SearchProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  SearchProductLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheSearchQuery(String query) {
    return sharedPreferences.setString(CACHED_SEARCH_QUERY_KEY, query);
  }

  @override
  Future<void> cacheProductSearch(ProductSearchModel productSearchModel) {
    return sharedPreferences.setString(
      CACHED_PRODUCT_SEARCH_KEY,
      json.encode(productSearchModel.toJson()),
    );
  }

  @override
  Future<String> getLastSearchQuery() {
    final queryString = sharedPreferences.getString(CACHED_SEARCH_QUERY_KEY);
    if (queryString != null) {
      return Future.value(queryString);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<ProductSearchModel> getLastSearch() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCT_SEARCH_KEY);
    if (jsonString != null) {
      return Future.value(ProductSearchModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}

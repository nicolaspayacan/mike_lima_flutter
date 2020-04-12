import 'package:mike_lima_clean_architecture/features/search_product/data/models/product_model.dart';
import 'package:meta/meta.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';

class ProductSearchModel extends ProductSearch {
  ProductSearchModel({
    @required String site_id,
    @required String query,
    @required List<ProductModel> results,
  }) : super(site_id: site_id, query: query, results: results);

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      site_id: json['site_id'],
      query: json['query'],
      results: (json['results'] as List)
          .map((productJson) => ProductModel.fromJson(productJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': site_id,
      'query': query,
      'results': (results?.map((productModel) =>
          (productModel as ProductModel).toJson()
      ))?.toList() ?? [],
    };
  }
}

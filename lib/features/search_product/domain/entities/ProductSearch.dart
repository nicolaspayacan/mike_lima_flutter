import 'package:equatable/equatable.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/Product.dart';
import 'package:meta/meta.dart';

class ProductSearch extends Equatable {
  final String siteId;
  final String query;
  final List<Product> results;

  ProductSearch(
      {@required this.siteId, @required this.query, @required this.results})
      : super([siteId, query, results]);
}

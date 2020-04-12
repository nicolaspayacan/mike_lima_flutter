import 'package:equatable/equatable.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/Product.dart';
import 'package:meta/meta.dart';

class ProductSearch extends Equatable {
  final String site_id;
  final String query;
  final List<Product> results;

  ProductSearch(
      {@required this.site_id, @required this.query, @required this.results})
      : super([site_id, query, results]);
}

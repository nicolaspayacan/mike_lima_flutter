import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';

@immutable
abstract class ProductSearchState extends Equatable {
  ProductSearchState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends ProductSearchState {}

class Loading extends ProductSearchState {}

class Loaded extends ProductSearchState {
  final ProductSearch productSearch;

  Loaded({@required this.productSearch}) : super([productSearch]);
}

class Error extends ProductSearchState {
  final String errorMessage;

  Error({@required this.errorMessage}) : super([errorMessage]);
}

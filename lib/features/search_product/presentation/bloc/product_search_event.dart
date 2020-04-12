import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductSearchEvent extends Equatable {
  ProductSearchEvent([List props = const <dynamic>[]]) : super(props);
}

class SearchProductEvent extends ProductSearchEvent {
  final String searchQuery;

  SearchProductEvent(this.searchQuery) : super([searchQuery]);
}

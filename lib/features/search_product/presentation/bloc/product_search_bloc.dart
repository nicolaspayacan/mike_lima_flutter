import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/usecases/search_product.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const SERVER_FAILURE_MESSAGE = "Server failure..";
const CACHE_FAILURE_MESSAGE = "Cache failure..";

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  final SearchProduct searchProduct;

  ProductSearchBloc({
    @required SearchProduct searchProduct,
  })  : assert(searchProduct != null),
        this.searchProduct = searchProduct;

  @override
  ProductSearchState get initialState => Empty();

  @override
  Stream<ProductSearchState> mapEventToState(
    ProductSearchEvent event,
  ) async* {
    if (event is SearchProductEvent) {
      yield Loading();

      final failureOrSearch = await searchProduct(
        Params(
          query: event.searchQuery,
        ),
      );

      yield failureOrSearch.fold(
        (failure) => Error(
          errorMessage: _mapFailureToMessage(failure),
        ),
        (searchResult) => Loaded(productSearch: searchResult),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error";
    }
  }
}

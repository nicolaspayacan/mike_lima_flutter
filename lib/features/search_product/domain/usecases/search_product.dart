import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/core/usecases/usecase.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/repositories/search_product_repository.dart';
import 'package:meta/meta.dart';

class SearchProduct implements UseCase<ProductSearch, Params> {
  final SearchProductRepository repository;

  SearchProduct(this.repository);

  @override
  Future<Either<Failure, ProductSearch>> call(
    Params params,
  ) async {
    return await repository.searchProduct(params.query);
  }
}

class Params extends Equatable {
  final String query;

  Params({@required this.query}): super([query]);
}

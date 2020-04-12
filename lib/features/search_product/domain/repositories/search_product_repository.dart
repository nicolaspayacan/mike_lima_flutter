import 'package:dartz/dartz.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';

abstract class SearchProductRepository {
  Future<Either<Failure, ProductSearch>> searchProduct(String query);
}
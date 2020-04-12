import 'package:dartz/dartz.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductDetail.dart';

abstract class ProductDetailRepository {
  Future<Either<Failure, ProductDetail>> getProductDetail(String productId);
}
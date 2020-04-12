import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/core/usecases/usecase.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductDetail.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/repositories/product_detail_repository.dart';

class GetProductDetail extends UseCase<ProductDetail, Params> {
  final ProductDetailRepository repository;

  GetProductDetail(this.repository);

  @override
  Future<Either<Failure, ProductDetail>> call(
    Params params,
  ) async {
    return repository.getProductDetail(params.productId);
  }
}

class Params extends Equatable {
  final String productId;

  Params({this.productId}) : super([productId]);
}

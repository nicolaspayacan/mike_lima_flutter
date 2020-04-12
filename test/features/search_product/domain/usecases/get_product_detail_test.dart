import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductDetail.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/repositories/product_detail_repository.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/usecases/get_product_detail.dart';

class MockProductDetailRepository extends Mock
    implements ProductDetailRepository {}

void main() {
  GetProductDetail useCase;
  MockProductDetailRepository mockSearchProductRepository;

  setUp(() {
    mockSearchProductRepository = MockProductDetailRepository();
    useCase = GetProductDetail(mockSearchProductRepository);
  });

  final productId = "123asd";
  final productDetail = ProductDetail();

  test(
    'should return detail of a product',
        () async {
      // arrange
      when(mockSearchProductRepository.getProductDetail(any))
          .thenAnswer((_) async => Right(productDetail));
      // act
      final result = await useCase(Params(productId: productId));

      // assert
      expect(result, Right(productDetail));
      verify(mockSearchProductRepository.getProductDetail(productId));
      verifyNoMoreInteractions(mockSearchProductRepository);
    },
  );
}

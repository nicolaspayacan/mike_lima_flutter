import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/Product.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/repositories/search_product_repository.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/usecases/search_product.dart';
import 'package:mockito/mockito.dart';

class MockSearchProductRepository extends Mock
    implements SearchProductRepository {}

void main() {
  SearchProduct useCase;
  MockSearchProductRepository mockSearchProductRepository;

  setUp(() {
    mockSearchProductRepository = MockSearchProductRepository();
    useCase = SearchProduct(mockSearchProductRepository);
  });

  final searchQuery = "remera";
  final searchResult = ProductSearch(
    siteId: "MLA",
    query: "remera",
    results: [Product(id: "1", title: "Remera", price: 22.3)],
  );

  test(
    'should return list of products',
    () async {
      // arrange
      when(mockSearchProductRepository.searchProduct(any))
          .thenAnswer((_) async => Right(searchResult));
      // act
      final result = await useCase(Params(query: searchQuery));

      // assert
      expect(result, Right(searchResult));
      verify(mockSearchProductRepository.searchProduct(searchQuery));
      verifyNoMoreInteractions(mockSearchProductRepository);
    },
  );
}

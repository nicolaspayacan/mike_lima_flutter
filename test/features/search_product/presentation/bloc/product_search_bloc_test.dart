import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'package:mike_lima_clean_architecture/core/error/failures.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/usecases/search_product.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';

class MockSearchProduct extends Mock implements SearchProduct {}

void main() {
  ProductSearchBloc bloc;
  MockSearchProduct mockSearchProduct;

  setUp(() {
    mockSearchProduct = MockSearchProduct();

    bloc = ProductSearchBloc(searchProduct: mockSearchProduct);
  });

  test(
    'initial state should be Empty',
    () {
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group('SearchProductEvent', () {
    final String tSearchQuery = "remera";
    final ProductSearch tProductSearch = ProductSearch(
      site_id: "MLA",
      query: tSearchQuery,
      results: [],
    );

    test(
      'should execute search product use case when SearchProductEvent is dispatched',
      () async {
        when(mockSearchProduct(any))
            .thenAnswer((_) async => Right(tProductSearch));
        bloc.dispatch(SearchProductEvent(tSearchQuery));
        await untilCalled(mockSearchProduct(any));
        verify(mockSearchProduct(Params(query: tSearchQuery)));
      },
    );

    prefix0.test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        when(mockSearchProduct(any))
            .thenAnswer((_) async => Right(tProductSearch));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(productSearch: tProductSearch),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(SearchProductEvent(tSearchQuery));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        when(mockSearchProduct(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(SearchProductEvent(tSearchQuery));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        when(mockSearchProduct(any))
            .thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(SearchProductEvent(tSearchQuery));
      },
    );

    test(
      'should emit [Error] when server fails',
      () async {
        when(mockSearchProduct(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Empty(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        bloc.dispatch(SearchProductEvent(tSearchQuery));
      },
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_bloc.dart';
import 'package:mike_lima_clean_architecture/injection_container.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<ProductSearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mike Lima'),
        ),
        body: Container(
          child: Center(
            child: Text('Product Detail'),
          ),
        ),
      ),
    );
  }
}

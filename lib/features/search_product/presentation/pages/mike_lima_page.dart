import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_bloc.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_event.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_state.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/loading_widget.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/message_display.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/search_result_display.dart';
import 'package:mike_lima_clean_architecture/injection_container.dart';

class MikeLimaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mike Lima"),
      ),
      body: buildBloc(context),
    );
  }

  BlocProvider<ProductSearchBloc> buildBloc(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<ProductSearchBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              BlocBuilder<ProductSearchBloc, ProductSearchState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return new MessageDisplay(
                      message: "Busque producto.!",
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Error) {
                    return new MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else if (state is Loaded) {
                    return SearchResultDisplay(
                      productSearch: state.productSearch,
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Placeholder(),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              new SearchControls()
            ],
          ),
        ),
      ),
    );
  }
}

class SearchControls extends StatefulWidget {
  const SearchControls({
    Key key,
  }) : super(key: key);

  @override
  _SearchControlsState createState() => _SearchControlsState();
}

class _SearchControlsState extends State<SearchControls> {
  String _inputStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Buscar..'),
            onChanged: (value) {
              _inputStream = value;
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Buscar'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: displatchProductSearch,
              ),
            ),
          ],
        )
      ],
    );
  }

  void displatchProductSearch() {
    BlocProvider.of<ProductSearchBloc>(context)
        .dispatch(SearchProductEvent(_inputStream));
  }
}

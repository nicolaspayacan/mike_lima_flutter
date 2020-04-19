import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_bloc.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_event.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/bloc/product_search_state.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/loading_widget.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/message_display.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/widgets/search_result_display.dart';
import 'package:mike_lima_clean_architecture/injection_container.dart';

class MikeLimaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<ProductSearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mike Lima'),
          actions: <Widget>[
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  final queryString = await showSearch(
                    context: context,
                    delegate: AppBarSearch(),
                  );
                  if (queryString != null) {
                    BlocProvider.of<ProductSearchBloc>(ctx)
                        .dispatch(SearchProductEvent(queryString));
                  }
                },
              ),
            ),
          ],
        ),
        body: buildBloc(context),
      ),
    );
  }

  Widget buildBloc(BuildContext context) {
    return Center(
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

class AppBarSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.amberAccent,
      backgroundColor: Colors.transparent
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }



  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }


  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(height: 20,);
  }

}

import 'package:flutter/material.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/Product.dart';
import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductSearch.dart';
import 'package:mike_lima_clean_architecture/features/search_product/presentation/pages/product_detail_page.dart';

class SearchResultDisplay extends StatelessWidget {
  final ProductSearch productSearch;

  const SearchResultDisplay({
    Key key,
    @required this.productSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
        itemCount: productSearch.results.length,
        itemBuilder: (BuildContext ctx, int index) {
//          return Text(productSearch.results[index].title);
          return ListTile(
            leading: Icon(Icons.print),
            title: Text(productSearch.results[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Row> renderProducts(List<Product> results) {
    List<Row> rows = [];
    results.forEach((item) {
      rows.add(
        Row(
          children: <Widget>[
            Text(item.title),
          ],
        ),
      );
    });
    return rows;
  }
}

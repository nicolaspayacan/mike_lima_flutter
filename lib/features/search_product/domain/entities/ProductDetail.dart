import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProductDetail extends Equatable {
  final String productId;
  final String siteId;
  final String title;
  final double price;
  final String currencyId;
  final int availableQuantity;

  ProductDetail({
    @required this.productId,
    @required this.siteId,
    @required this.title,
    @required this.price,
    @required this.currencyId,
    @required this.availableQuantity,
  }) : super([productId, siteId, title, price, currencyId, availableQuantity]);
}

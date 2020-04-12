import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final double price;

  Product({@required this.id, @required this.title, @required this.price})
      : super([id, title, price]);
}

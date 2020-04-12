import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/Product.dart';
import 'package:meta/meta.dart';

class ProductModel extends Product {
  ProductModel({
    @required String id,
    @required String title,
    @required double price,
  }) : super(id: id, title: title, price: price);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
    };
  }
}

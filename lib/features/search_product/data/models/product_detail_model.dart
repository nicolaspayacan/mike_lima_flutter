import 'package:mike_lima_clean_architecture/features/search_product/domain/entities/ProductDetail.dart';
import 'package:meta/meta.dart';

class ProductDetailModel extends ProductDetail {
  ProductDetailModel({
    @required String productId,
    @required String siteId,
    @required String title,
    @required double price,
    @required String currencyId,
    @required int availableQuantity,
  }) : super(
          productId: productId,
          siteId: siteId,
          title: title,
          price: price,
          currencyId: currencyId,
          availableQuantity: availableQuantity,
        );

  factory ProductDetailModel.fromJson(List<dynamic> json) {
    final Map<String, dynamic> productDetailJson =
        json[0]['body'] as Map<String, dynamic>;
    return ProductDetailModel(
        productId: productDetailJson['id'],
        siteId: productDetailJson['site_id'],
        title: productDetailJson['title'],
        price: (productDetailJson['price'] as num).toDouble(),
        currencyId: productDetailJson['currency_id'],
        availableQuantity: productDetailJson['available_quantity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'site_id': siteId,
      'title': title,
      'price': price,
      'currency_id': currencyId,
      'available_quantity': availableQuantity
    };
  }
}

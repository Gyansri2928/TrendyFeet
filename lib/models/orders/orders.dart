import 'package:json_annotation/json_annotation.dart';
import '../product/product.dart';

part 'orders.g.dart';

@JsonSerializable()
class Orders {
  @JsonKey(name: "total_price")
  double totalPrice;

  @JsonKey(name: "delivery_address")
  String deliveryAddress;

  @JsonKey(name: "payment_method")
  String paymentMethod;

  @JsonKey(name: "order_placed_time")
  DateTime orderPlacedTime;

  @JsonKey(name: "products")
  List<Product>? products; // List of products (optional)

  @JsonKey(name: "product_quantities")
  Map<String, int> productQuantities;

  Orders({
    required this.totalPrice,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.orderPlacedTime,
    this.products,
    required this.productQuantities
  });

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}
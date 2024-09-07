// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Orders _$OrdersFromJson(Map<String, dynamic> json) => Orders(
      totalPrice: (json['total_price'] as num).toDouble(),
      deliveryAddress: json['delivery_address'] as String,
      paymentMethod: json['payment_method'] as String,
      orderPlacedTime: DateTime.parse(json['order_placed_time'] as String),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      productQuantities:
          Map<String, int>.from(json['product_quantities'] as Map),
    );

Map<String, dynamic> _$OrdersToJson(Orders instance) => <String, dynamic>{
      'total_price': instance.totalPrice,
      'delivery_address': instance.deliveryAddress,
      'payment_method': instance.paymentMethod,
      'order_placed_time': instance.orderPlacedTime.toIso8601String(),
      'products': instance.products,
      'product_quantities': instance.productQuantities,
    };

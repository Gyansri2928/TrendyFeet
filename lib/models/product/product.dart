import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "category")
  String? category;

  @JsonKey(name: "Image")
  String? image;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "brand")
  String? brand;

  @JsonKey(name: "offer")
  bool? offer;

  @JsonKey(name: "quantity")
  int? quantity;

  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.image,
    this.offer,
    this.price,
    this.brand,
    this.quantity
  });

  // Add the copyWith method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? image,
    double? price,
    String? brand,
    bool? offer,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      price: price ?? this.price,
      brand: brand ?? this.brand,
      offer: offer ?? this.offer,
      quantity: quantity ?? this.quantity,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
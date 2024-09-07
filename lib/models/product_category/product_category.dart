import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  bool isSelected; // New field for selection status

  ProductCategory({
    this.id,
    this.name,
    this.isSelected = false, // Initialize isSelected to false by default
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

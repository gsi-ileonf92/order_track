//* features/allocator/domain/entities/order.dart
import 'package:order_track/features/allocator/domain/entities/product.dart';

class ProductModel {
  final String id;
  final String name;
  final int stock;
  final bool isAvailable;

  ProductModel({
    required this.id,
    required this.name,
    required this.stock,
    required this.isAvailable,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      stock: json['stock'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'isAvailable': isAvailable,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      stock: stock,
      isAvailable: isAvailable,
    );
  }

  static ProductModel fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      stock: product.stock,
      isAvailable: product.isAvailable,
    );
  }
}

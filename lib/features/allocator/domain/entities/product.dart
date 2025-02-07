//* features/allocator/domain/entities/product.dart
class Product {
  final String id;
  final String name;
  final int stock;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.isAvailable,
  });

  Product copyWith({
    String? id,
    String? name,
    int? stock,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

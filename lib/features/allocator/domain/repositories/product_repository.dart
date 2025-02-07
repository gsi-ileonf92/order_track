// features/allocator/domain/repositories/product_repository.dart
import 'package:order_track/features/allocator/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<Product> updateProduct(Product product);
}

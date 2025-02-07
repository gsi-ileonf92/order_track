import 'package:order_track/features/allocator/data/datasources/product_remote_data_source.dart';
import 'package:order_track/features/allocator/domain/entities/product.dart';
import 'package:order_track/features/allocator/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final products = await remoteDataSource.getProducts();
    return products;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final response = await remoteDataSource.updateProduct(product);
    return response;
  }

  @override
  Future<Product> getProductById(String id) async {
    final response = await remoteDataSource.getProductById(id);
    return response;
  }
}

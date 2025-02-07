import 'package:dio/dio.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/features/allocator/data/models/products_model.dart';
import 'package:order_track/features/allocator/domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<Product> updateProduct(Product product);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await dioClient.get(Endpoints.getProducts());
      return (response.data as List)
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await dioClient.put(
        Endpoints.updateProductById(id: product.id),
        data: ProductModel.fromEntity(product).toJson(),
      );
      return ProductModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to update orders: ${e.message}');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dioClient.get(Endpoints.getProductById(id: id));
      return ProductModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to fetch products: ${e.message}');
    }
  }
}

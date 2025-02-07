// features/allocator/domain/usecases/get_orders_usecase.dart
import 'package:order_track/core/usecases/no_params.dart';
import 'package:order_track/core/usecases/use_case.dart';
import 'package:order_track/features/allocator/domain/entities/product.dart';
import 'package:order_track/features/allocator/domain/repositories/product_repository.dart';

class GetProductsUsecase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getProducts();
  }
}

class GetProductByIdUsecase implements UseCase<Product, String> {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  @override
  Future<Product> call(String id) async {
    return await repository.getProductById(id);
  }
}

class UpdateProductUsecase implements UseCase<Product, Product> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Product> call(Product value) async {
    return await repository.updateProduct(value);
  }
}

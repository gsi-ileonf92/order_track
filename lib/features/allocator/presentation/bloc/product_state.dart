part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
  Product get product =>
      throw UnimplementedError("Product not available in this state");
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

class ProductsListUpdated extends ProductState {
  final List<Product> products;

  const ProductsListUpdated({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductUpdated extends ProductState {
  final Product _product;

  const ProductUpdated({required Product product}) : _product = product;

  @override
  List<Object> get props => [_product];

  @override
  Product get product => _product;
}

class ProductByIdUpdated extends ProductState {
  final Product _product;

  const ProductByIdUpdated({required Product product}) : _product = product;

  @override
  List<Object> get props => [_product];

  @override
  Product get product => _product;
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductStockAdjusted extends ProductState {
  final Product _product;
  final int adjustedStock;

  const ProductStockAdjusted(
      {required Product product, required this.adjustedStock})
      : _product = product;

  @override
  List<Object> get props => [_product, adjustedStock];

  @override
  Product get product => _product;
}

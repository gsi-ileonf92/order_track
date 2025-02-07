part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsEvent extends ProductEvent {}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent(this.product);
}

class AdjustProductStock extends ProductEvent {
  final int stockChange;

  const AdjustProductStock(this.stockChange);
}

class GetProductByIdEvent extends ProductEvent {
  final String id;

  const GetProductByIdEvent(this.id);
}

class SaveProduct extends ProductEvent {}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_track/core/usecases/no_params.dart';
import 'package:order_track/core/utils/utils.dart';
import 'package:order_track/features/allocator/domain/entities/product.dart';
import 'package:order_track/features/allocator/domain/usecases/product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final GetProductByIdUsecase getProductByIdUsecase;

  ProductBloc({
    required this.getProductsUsecase,
    required this.updateProductUsecase,
    required this.getProductByIdUsecase,
  }) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<UpdateProductEvent>(_updateProduct);
    on<GetProductByIdEvent>(_onGetProductById);
    on<AdjustProductStock>(_onAdjustProductStock);
    on<SaveProduct>(_onSaveProduct);
  }

  void _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await getProductsUsecase(NoParams());
      emit(ProductsListUpdated(products: products));
    } catch (e) {
      emit(ProductError(message: 'Failed to fetch product'));
    }
  }

  void _updateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await updateProductUsecase(event.product);
      emit(ProductUpdated(product: product));
    } catch (e) {
      emit(ProductError(message: 'Failed to update product'));
    }
  }

  void _onGetProductById(
      GetProductByIdEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await getProductByIdUsecase(event.id);
      emit(ProductByIdUpdated(product: product));
    } catch (e) {
      emit(ProductError(message: 'Failed to get product'));
    }
  }

  void _onAdjustProductStock(
      AdjustProductStock event, Emitter<ProductState> emit) async {
    if (state is ProductByIdUpdated) {
      final currentState = state as ProductByIdUpdated;
      final updatedStock = currentState.product.stock + event.stockChange;
      final updatedProduct = currentState.product.copyWith(stock: updatedStock);
      Utils.logDebug(
        "emitting current product stock: ${updatedProduct.stock}",
        methodCount: 0,
      );
      emit(
        ProductStockAdjusted(
          product: updatedProduct,
          adjustedStock: updatedStock,
        ),
      );
    } else if (state is ProductStockAdjusted) {
      final currentState = state as ProductStockAdjusted;
      final updatedStock = currentState.product.stock + event.stockChange;
      final updatedProduct = currentState.product.copyWith(stock: updatedStock);
      Utils.logDebug(
        "emitting current product stock: ${updatedProduct.stock}",
        methodCount: 0,
      );
      emit(
        ProductStockAdjusted(
          product: updatedProduct,
          adjustedStock: updatedStock,
        ),
      );
    }
  }

  void _onSaveProduct(SaveProduct event, Emitter<ProductState> emit) async {
    if (state is ProductStockAdjusted) {
      final currentState = state as ProductStockAdjusted;
      emit(ProductLoading());
      try {
        final updatedProduct = await updateProductUsecase(currentState.product);
        emit(ProductUpdated(product: updatedProduct));
      } catch (e) {
        emit(ProductError(message: 'Failed to save product'));
      }
    }
  }
}

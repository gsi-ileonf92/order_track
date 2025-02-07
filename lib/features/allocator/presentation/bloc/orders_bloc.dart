import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_track/core/usecases/no_params.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/domain/usecases/order_usecase.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUsecase getOrdersUseCase;
  final AddOrderUsecase addOrderUsecase;
  final UpdateOrderUsecase updateOrderUsecase;
  final DeleteOrderUsecase deleteOrderUsecase;

  OrdersBloc({
    required this.getOrdersUseCase,
    required this.addOrderUsecase,
    required this.updateOrderUsecase,
    required this.deleteOrderUsecase,
  }) : super(OrdersInitial()) {
    on<FetchOrdersEvent>(_onFetchOrders);
    on<AddOrderEvent>(_onAddOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
  }

  void _onFetchOrders(FetchOrdersEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final orders = await getOrdersUseCase(NoParams());
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to fetch orders'));
    }
  }

  void _onAddOrder(AddOrderEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final newOrder = await addOrderUsecase(event.order);
      final updatedOrders = List<Order>.from((state as OrdersLoaded).orders)
        ..add(newOrder);
      emit(OrdersLoaded(updatedOrders));
    } catch (e) {
      emit(OrdersError('Failed to add order'));
    }
  }

  void _onUpdateOrder(UpdateOrderEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final updatedOrder = await updateOrderUsecase(event.order);
      final updatedOrders = (state as OrdersLoaded)
          .orders
          .map((order) => order.id == updatedOrder.id ? updatedOrder : order)
          .toList();
      emit(OrdersLoaded(updatedOrders));
    } catch (e) {
      emit(OrdersError('Failed to update order'));
    }
  }

  void _onDeleteOrder(DeleteOrderEvent event, Emitter<OrdersState> emit) async {
    emit(OrdersLoading());
    try {
      await deleteOrderUsecase(event.id);
      final updatedOrders = (state as OrdersLoaded)
          .orders
          .where((order) => order.id != event.id)
          .toList();
      emit(OrdersLoaded(updatedOrders));
    } catch (e) {
      emit(OrdersError('Failed to delete order'));
    }
  }
}

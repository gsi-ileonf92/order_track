part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class FetchOrdersEvent extends OrdersEvent {}

class AddOrderEvent extends OrdersEvent {
  final Order order;

  const AddOrderEvent(this.order);
}

class UpdateOrderEvent extends OrdersEvent {
  final Order order;

  const UpdateOrderEvent(this.order);
}

class DeleteOrderEvent extends OrdersEvent {
  final int id;

  const DeleteOrderEvent(this.id);
}

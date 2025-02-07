part of 'order_details_bloc.dart';

sealed class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object> get props => [];
}

class ToggleEditMode extends OrderDetailsEvent {}

class UpdateOrderDescription extends OrderDetailsEvent {
  final String orderDescription;

  const UpdateOrderDescription(this.orderDescription);
}

class UpdateDeliveryDate extends OrderDetailsEvent {
  final String deliveryDate;

  const UpdateDeliveryDate(this.deliveryDate);
}

class UpdateOrderStatus extends OrderDetailsEvent {
  final String orderStatus;

  const UpdateOrderStatus(this.orderStatus);
}

class UpdateProductQuantity extends OrderDetailsEvent {
  final int productQuantity;

  const UpdateProductQuantity(this.productQuantity);
}

class UpdateDistributorId extends OrderDetailsEvent {
  final String distributorId;

  const UpdateDistributorId(this.distributorId);
}

class FetchDistributorsEvent extends OrderDetailsEvent {}

class CreateOrder extends OrderDetailsEvent {
  final Order order;

  const CreateOrder(this.order);
}

class UpdateOrder extends OrderDetailsEvent {
  final Order order;

  const UpdateOrder(this.order);
}

class ResetUpdateStatus extends OrderDetailsEvent {
  const ResetUpdateStatus();
}

class DeleteOrder extends OrderDetailsEvent {
  final int id;

  const DeleteOrder(this.id);
}

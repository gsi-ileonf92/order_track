part of 'distributor_orders_bloc.dart';

abstract class DistributorOrdersState {}

class DistributorOrdersInitial extends DistributorOrdersState {}

class DistributorOrdersLoading extends DistributorOrdersState {}

class DistributorOrdersLoaded extends DistributorOrdersState {
  final List<Order> orders;

  DistributorOrdersLoaded(this.orders);
}

class DistributorOrdersError extends DistributorOrdersState {
  final String message;

  DistributorOrdersError(this.message);
}

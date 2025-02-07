part of 'distributor_orders_bloc.dart';

sealed class DistributorOrdersEvent extends Equatable {
  const DistributorOrdersEvent();

  @override
  List<Object> get props => [];
}

class GetDistributorOrdersEvent extends DistributorOrdersEvent {
  final String id;

  const GetDistributorOrdersEvent(this.id);

  @override
  List<Object> get props => [id];
}

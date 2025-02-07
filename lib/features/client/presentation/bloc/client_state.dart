part of 'client_bloc.dart';

abstract class ClientState extends Equatable {
  const ClientState();

  @override
  List<Object> get props => [];
}

class ClientOrdersInitial extends ClientState {}

class ClientOrdersLoading extends ClientState {}

class ClientOrdersLoaded extends ClientState {
  final List<Order> orders;

  const ClientOrdersLoaded(this.orders);
}

class ClientOrdersError extends ClientState {
  final String message;

  const ClientOrdersError(this.message);
}

class OrderConfirmedSuccessfully extends ClientState {}

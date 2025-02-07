part of 'client_bloc.dart';

abstract class ClientEvent extends Equatable {
  const ClientEvent();

  @override
  List<Object> get props => [];
}

class GetClientOrdersEvent extends ClientEvent {
  final String id;

  const GetClientOrdersEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ConfirmOrderReceivedEvent extends ClientEvent {
  final String orderId;

  const ConfirmOrderReceivedEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

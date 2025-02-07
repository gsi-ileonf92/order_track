import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/client/domain/usecases/client_get_orders_usecase.dart';
import 'package:order_track/features/client/domain/usecases/confirm_order_received_usecase.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientGetOrdersUsecase getOrdersUsecase;
  final ConfirmOrderReceivedUseCase confirmOrderReceivedUseCase;

  ClientBloc(
      {required this.getOrdersUsecase,
      required this.confirmOrderReceivedUseCase})
      : super(ClientOrdersInitial()) {
    on<GetClientOrdersEvent>(_onFetchOrders);
    on<ConfirmOrderReceivedEvent>(_onConfirmOrderReceived);
  }

  void _onFetchOrders(
      GetClientOrdersEvent event, Emitter<ClientState> emit) async {
    emit(ClientOrdersLoading());
    try {
      final orders = await getOrdersUsecase(event.id);
      emit(ClientOrdersLoaded(orders));
    } catch (e) {
      emit(ClientOrdersError('Failed to fetch orders'));
    }
  }

  void _onConfirmOrderReceived(
      ConfirmOrderReceivedEvent event, Emitter<ClientState> emit) async {
    final result = await confirmOrderReceivedUseCase(event.orderId);
    result.fold(
      (failure) => emit(ClientOrdersError(failure.message)),
      (_) => emit(OrderConfirmedSuccessfully()),
    );
  }
}

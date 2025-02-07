import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/features/allocator/data/models/distributor_model.dart';
import 'package:order_track/features/allocator/data/models/order_model.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';

part 'order_details_event.dart';
part 'order_details_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final Order order;
  final DioClient dioClient;

  OrderDetailsBloc({required this.order, required this.dioClient})
      : super(OrderDetailsState(order: order)) {
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateOrderDescription>(_onUpdateOrderDescription);
    on<UpdateDeliveryDate>(_onUpdateDeliveryDate);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<ResetUpdateStatus>(_onResetUpdateStatus);
    on<UpdateProductQuantity>(_onUpdateProductQuantity);
    on<UpdateDistributorId>(_onUpdateDistributorId);
    on<FetchDistributorsEvent>(_onFetchDistributors);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrder>(_onUpdateOrder);
    on<DeleteOrder>(_onDeleteOrder);
  }

  void _onToggleEditMode(
      ToggleEditMode event, Emitter<OrderDetailsState> emit) {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  void _onUpdateOrderDescription(
      UpdateOrderDescription event, Emitter<OrderDetailsState> emit) {
    final updatedOrder =
        state.order.copyWith(orderDescription: event.orderDescription);
    emit(state.copyWith(order: updatedOrder));
  }

  void _onUpdateDeliveryDate(
      UpdateDeliveryDate event, Emitter<OrderDetailsState> emit) {
    final updatedOrder = state.order.copyWith(deliveryDate: event.deliveryDate);
    emit(state.copyWith(order: updatedOrder));
  }

  void _onUpdateOrderStatus(
      UpdateOrderStatus event, Emitter<OrderDetailsState> emit) {
    final updatedOrder = state.order.copyWith(orderStatus: event.orderStatus);
    emit(state.copyWith(order: updatedOrder));
  }

  void _onUpdateProductQuantity(
      UpdateProductQuantity event, Emitter<OrderDetailsState> emit) {
    final updatedOrder =
        state.order.copyWith(prodQuantity: event.productQuantity);
    emit(state.copyWith(order: updatedOrder));
  }

  void _onUpdateDistributorId(
      UpdateDistributorId event, Emitter<OrderDetailsState> emit) {
    final updatedOrder =
        state.order.copyWith(distributorId: event.distributorId);
    emit(state.copyWith(order: updatedOrder));
  }

  void _onFetchDistributors(
      FetchDistributorsEvent event, Emitter<OrderDetailsState> emit) async {
    emit(state.copyWith(isLoading: true, isActionsEnabled: false));
    try {
      final response = await dioClient.get(Endpoints.getDistributors());
      final distributors = (response.data as List)
          .map((json) => DistributorModel.fromJson(json))
          .where(
            (distributor) => distributor.isAvailable,
          )
          .toList();
      emit(state.copyWith(
          isLoading: false,
          distributors: distributors,
          isActionsEnabled: true));
    } catch (e) {
      // Handle error
      emit(state.copyWith(
        error: "Error obteniendo los distribuidores!",
        isLoading: false,
        isActionsEnabled: true,
      ));
    }
  }

  void _onCreateOrder(
      CreateOrder event, Emitter<OrderDetailsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final orderModel = OrderModel.fromEntity(event.order);
      final response = await dioClient.post(
        Endpoints.postOrder(),
        data: orderModel.toJson(),
      );
      if (response.statusCode == 200) {
        final createdOrder = OrderModel.fromJson(response.data);
        emit(state.copyWith(
            order: createdOrder.toEntity(), isLoading: false, isCreated: true));
      } else {
        emit(state.copyWith(error: response.statusMessage, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onUpdateOrder(
      UpdateOrder event, Emitter<OrderDetailsState> emit) async {
    emit(state.copyWith(isLoading: true, isActionsEnabled: false));
    try {
      final orderModel = OrderModel.fromEntity(event.order);
      final response = await dioClient.put(
        Endpoints.updateOrderById(id: event.order.id),
        data: orderModel.toJson(),
      );
      if (response.statusCode == 200) {
        final updatedOrder = OrderModel.fromJson(response.data);
        emit(state.copyWith(
          order: updatedOrder.toEntity(),
          isLoading: false,
          isUpdated: true,
          isActionsEnabled: true,
        ));
      } else {
        emit(state.copyWith(
          error: response.statusMessage,
          isLoading: false,
          isActionsEnabled: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
        isActionsEnabled: true,
      ));
    }
  }

  void _onDeleteOrder(
      DeleteOrder event, Emitter<OrderDetailsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await dioClient.delete(
        Endpoints.deleteOrderById(id: event.id),
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false, isDeleted: true));
      } else {
        emit(state.copyWith(error: response.statusMessage, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onResetUpdateStatus(
      ResetUpdateStatus event, Emitter<OrderDetailsState> emit) async {
    emit(state.copyWith(isUpdated: false));
  }
}

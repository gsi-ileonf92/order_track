import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/distributor/domain/usecases/distributor_get_orders_usecase.dart';

part 'distributor_orders_event.dart';
part 'distributor_orders_state.dart';

class DistributorOrdersBloc
    extends Bloc<DistributorOrdersEvent, DistributorOrdersState> {
  final DistributorGetOrdersUsecase getOrdersUseCase;

  DistributorOrdersBloc({
    required this.getOrdersUseCase,
  }) : super(DistributorOrdersInitial()) {
    on<GetDistributorOrdersEvent>(_onFetchOrders);
  }

  void _onFetchOrders(GetDistributorOrdersEvent event,
      Emitter<DistributorOrdersState> emit) async {
    emit(DistributorOrdersLoading());
    try {
      final orders = await getOrdersUseCase(event.id);
      emit(DistributorOrdersLoaded(orders));
    } catch (e) {
      emit(DistributorOrdersError('Failed to fetch orders'));
    }
  }
}

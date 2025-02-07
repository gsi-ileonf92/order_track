// features/allocator/domain/usecases/get_orders_usecase.dart
import 'package:order_track/core/usecases/no_params.dart';
import 'package:order_track/core/usecases/use_case.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/domain/repositories/order_repository.dart';

class GetOrdersUsecase implements UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  GetOrdersUsecase(this.repository);

  @override
  Future<List<Order>> call(NoParams params) async {
    return await repository.getOrders();
  }
}

class AddOrderUsecase implements UseCase<Order, Order> {
  final OrderRepository repository;

  AddOrderUsecase(this.repository);

  @override
  Future<Order> call(Order order) async {
    return await repository.addOrder(order);
  }
}

class UpdateOrderUsecase implements UseCase<Order, Order> {
  final OrderRepository repository;

  UpdateOrderUsecase(this.repository);

  @override
  Future<Order> call(Order order) async {
    return await repository.updateOrder(order);
  }
}

class DeleteOrderUsecase implements UseCase<void, int> {
  final OrderRepository repository;

  DeleteOrderUsecase(this.repository);

  @override
  Future<void> call(int id) async {
    return await repository.deleteOrder(id);
  }
}

import 'package:order_track/core/usecases/use_case.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/distributor/domain/repositories/distributor_order_repository.dart';

class DistributorGetOrdersUsecase implements UseCase<List<Order>, String> {
  final DistributorOrderRepository repository;

  DistributorGetOrdersUsecase(this.repository);

  @override
  Future<List<Order>> call(String id) async {
    return await repository.getOrdersForDistributor(id);
  }
}

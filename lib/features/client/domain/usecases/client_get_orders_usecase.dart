import 'package:order_track/core/usecases/use_case.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/client/domain/repositories/client_repository.dart';

class ClientGetOrdersUsecase implements UseCase<List<Order>, String> {
  final ClientRepository repository;

  ClientGetOrdersUsecase(this.repository);

  @override
  Future<List<Order>> call(String id) async {
    return await repository.getOrdersForClient(id);
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart'
    as order;

abstract class ClientRepository {
  Future<List<order.Order>> getOrdersForClient(String id);
  Future<Either<Failure, void>> confirmOrderReceived(String orderId);
}

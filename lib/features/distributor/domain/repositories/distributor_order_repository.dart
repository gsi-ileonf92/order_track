import 'package:order_track/features/allocator/domain/entities/order.dart';

abstract class DistributorOrderRepository {
  Future<List<Order>> getOrdersForDistributor(String id);
}

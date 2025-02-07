// features/allocator/domain/repositories/order_repository.dart
import 'package:order_track/features/allocator/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> addOrder(Order order);
  Future<Order> updateOrder(Order order);
  Future<void> deleteOrder(int id);
}

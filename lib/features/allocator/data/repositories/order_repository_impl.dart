import 'package:order_track/features/allocator/data/datasources/order_remote_data_source.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/allocator/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Order>> getOrders() async {
    final orders = await remoteDataSource.getOrders();
    return orders;
  }

  @override
  Future<Order> addOrder(Order order) async {
    final response = await remoteDataSource.addOrder(order);
    return response;
  }

  @override
  Future<Order> updateOrder(Order order) async {
    final response = await remoteDataSource.updateOrder(order);
    return response;
  }

  @override
  Future<void> deleteOrder(int id) async {
    await remoteDataSource.deleteOrder(id);
  }
}

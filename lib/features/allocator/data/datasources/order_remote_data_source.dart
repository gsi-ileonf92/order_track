import 'package:dio/dio.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/features/allocator/data/models/order_model.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';

abstract class OrderRemoteDataSource {
  Future<List<Order>> getOrders();
  Future<Order> addOrder(Order order);
  Future<Order> updateOrder(Order order);
  Future<void> deleteOrder(int id);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final DioClient dioClient;

  OrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Order>> getOrders() async {
    try {
      final response = await dioClient.get(Endpoints.getOrders());
      return (response.data as List)
          .map((json) => OrderModel.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    }
  }

  @override
  Future<Order> addOrder(Order order) async {
    try {
      final response = await dioClient.post(
        Endpoints.postOrder(),
        data: OrderModel.fromEntity(order).toJson(),
      );
      return OrderModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to add orders: ${e.message}');
    }
  }

  @override
  Future<Order> updateOrder(Order order) async {
    try {
      final response = await dioClient.put(
        Endpoints.updateOrderById(id: order.id),
        data: OrderModel.fromEntity(order).toJson(),
      );
      return OrderModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to update order: ${e.message}');
    }
  }

  @override
  Future<void> deleteOrder(int id) async {
    try {
      await dioClient.delete(
        Endpoints.deleteOrderById(id: id),
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete order: ${e.message}');
    }
  }
}

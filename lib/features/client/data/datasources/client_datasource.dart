import 'package:dio/dio.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/features/allocator/data/models/order_model.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';

abstract class ClientRemoteDataSource {
  Future<List<Order>> getOrdersByClientId(String id);
  Future<void> confirmOrderReceived(String orderId);
}

class ClientRemoteDataSourceImpl implements ClientRemoteDataSource {
  final DioClient dioClient;

  ClientRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Order>> getOrdersByClientId(String id) async {
    try {
      final response =
          await dioClient.get(Endpoints.getOrdersByClientId(id: id));
      return (response.data as List)
          .map((json) => OrderModel.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    }
  }

  @override
  Future<void> confirmOrderReceived(String orderId) async {
    await dioClient.post('/orders/$orderId/confirm');
  }
}

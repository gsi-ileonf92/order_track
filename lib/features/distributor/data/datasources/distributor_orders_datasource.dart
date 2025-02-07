import 'package:dio/dio.dart';
import 'package:order_track/core/network/dio_client.dart';
import 'package:order_track/core/network/endpoints.dart';
import 'package:order_track/features/allocator/data/models/order_model.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';

abstract class DistributorOrderRemoteDataSource {
  Future<List<Order>> getOrdersByDistributorId(String id);
}

class DistributorOrderRemoteDataSourceImpl
    implements DistributorOrderRemoteDataSource {
  final DioClient dioClient;

  DistributorOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Order>> getOrdersByDistributorId(String id) async {
    try {
      final response =
          await dioClient.get(Endpoints.getOrdersByDistributorId(id: id));
      return (response.data as List)
          .map((json) => OrderModel.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch orders: ${e.message}');
    }
  }
}

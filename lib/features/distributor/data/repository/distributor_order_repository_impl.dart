import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/distributor/data/datasources/distributor_orders_datasource.dart';
import 'package:order_track/features/distributor/domain/repositories/distributor_order_repository.dart';

class DistributorOrderRepositoryImpl implements DistributorOrderRepository {
  final DistributorOrderRemoteDataSource remoteDataSource;

  const DistributorOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> getOrdersForDistributor(String id) async {
    final orders = await remoteDataSource.getOrdersByDistributorId(id);
    return orders;
  }
}

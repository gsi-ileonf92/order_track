import 'package:fpdart/src/either.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/allocator/domain/entities/order.dart';
import 'package:order_track/features/client/data/datasources/client_datasource.dart';
import 'package:order_track/features/client/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientRemoteDataSource remoteDataSource;

  const ClientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> getOrdersForClient(String id) async {
    final orders = await remoteDataSource.getOrdersByClientId(id);
    return orders;
  }

  @override
  Future<Either<Failure, void>> confirmOrderReceived(String orderId) async {
    try {
      await remoteDataSource.confirmOrderReceived(orderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

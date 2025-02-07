import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/core/usecases/use_case.dart';
import 'package:order_track/features/client/domain/repositories/client_repository.dart';

class ConfirmOrderReceivedUseCase extends UseCase<void, String> {
  final ClientRepository repository;

  ConfirmOrderReceivedUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String orderId) async {
    return await repository.confirmOrderReceived(orderId);
  }
}

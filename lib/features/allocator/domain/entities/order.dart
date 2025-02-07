//* features/allocator/domain/entities/order.dart
class Order {
  final int id;
  final String clientId;
  final String clientName;
  final String orderDescription;
  final String deliveryDate;
  final String orderStatus;
  final int prodQuantity;
  final String distributorId;
  final String productId;

  Order({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.orderDescription,
    required this.deliveryDate,
    required this.orderStatus,
    required this.prodQuantity,
    required this.distributorId,
    required this.productId,
  });

  Order copyWith({
    int? id,
    String? clientId,
    String? clientName,
    String? orderDescription,
    String? deliveryDate,
    String? orderStatus,
    int? prodQuantity,
    String? distributorId,
    String? productId,
  }) {
    return Order(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      orderDescription: orderDescription ?? this.orderDescription,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      orderStatus: orderStatus ?? this.orderStatus,
      prodQuantity: prodQuantity ?? this.prodQuantity,
      distributorId: distributorId ?? this.distributorId,
      productId: productId ?? this.productId,
    );
  }
}

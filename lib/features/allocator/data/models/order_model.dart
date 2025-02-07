import 'package:order_track/features/allocator/domain/entities/order.dart';

class OrderModel {
  final int id;
  final String clientId;
  final String clientName;
  final String orderDescription;
  final String deliveryDate;
  final String orderStatus;
  final int prodQuantity;
  final String distributorId;
  final String productId;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      orderDescription: json['orderDescription'],
      deliveryDate: json['deliveryDate'],
      orderStatus: json['orderStatus'],
      prodQuantity: json['prodQuantity'],
      distributorId: json['distributorId'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'orderDescription': orderDescription,
      'deliveryDate': deliveryDate,
      'orderStatus': orderStatus,
      'prodQuantity': prodQuantity,
      'distributorId': distributorId,
      'productId': productId,
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      clientId: clientId,
      clientName: clientName,
      orderDescription: orderDescription,
      deliveryDate: deliveryDate,
      orderStatus: orderStatus,
      prodQuantity: prodQuantity,
      distributorId: distributorId,
      productId: productId,
    );
  }

  static OrderModel fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      clientId: order.clientId,
      clientName: order.clientName,
      orderDescription: order.orderDescription,
      deliveryDate: order.deliveryDate,
      orderStatus: order.orderStatus,
      prodQuantity: order.prodQuantity,
      distributorId: order.distributorId,
      productId: order.productId,
    );
  }
}

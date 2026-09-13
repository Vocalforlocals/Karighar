import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String productId;
  final String productTitle;
  final String productImage;
  final String artisanName;
  final String buyerName;
  final int quantity;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'in_loom', 'shipped', 'delivered'
  final DateTime orderDate;
  final String deliveryAddress;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.artisanName,
    required this.buyerName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
  });

  OrderItem copyWith({
    String? id,
    String? productId,
    String? productTitle,
    String? productImage,
    String? artisanName,
    String? buyerName,
    int? quantity,
    double? totalPrice,
    String? status,
    DateTime? orderDate,
    String deliveryAddress = '',
  }) {
    return OrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      artisanName: artisanName ?? this.artisanName,
      buyerName: buyerName ?? this.buyerName,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      deliveryAddress: deliveryAddress.isEmpty ? this.deliveryAddress : deliveryAddress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        productTitle,
        productImage,
        artisanName,
        buyerName,
        quantity,
        totalPrice,
        status,
        orderDate,
        deliveryAddress,
      ];
}

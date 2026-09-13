import 'package:equatable/equatable.dart';

class BulkQuote extends Equatable {
  final String id;
  final String productId;
  final String productTitle;
  final String buyerName;
  final String buyerOrg;
  final int requestedQuantity;
  final double targetPricePerUnit;
  final String? artisanCounterPrice;
  final String status; // 'pending', 'countered', 'accepted', 'rejected'
  final DateTime requestedAt;
  final String notes;

  const BulkQuote({
    required this.id,
    required this.productId,
    required this.productTitle,
    required this.buyerName,
    required this.buyerOrg,
    required this.requestedQuantity,
    required this.targetPricePerUnit,
    this.artisanCounterPrice,
    required this.status,
    required this.requestedAt,
    required this.notes,
  });

  BulkQuote copyWith({
    String? id,
    String? productId,
    String? productTitle,
    String? buyerName,
    String? buyerOrg,
    int? requestedQuantity,
    double? targetPricePerUnit,
    String? artisanCounterPrice,
    String? status,
    DateTime? requestedAt,
    String? notes,
  }) {
    return BulkQuote(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      buyerName: buyerName ?? this.buyerName,
      buyerOrg: buyerOrg ?? this.buyerOrg,
      requestedQuantity: requestedQuantity ?? this.requestedQuantity,
      targetPricePerUnit: targetPricePerUnit ?? this.targetPricePerUnit,
      artisanCounterPrice: artisanCounterPrice ?? this.artisanCounterPrice,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      notes: notes ?? this.notes,
    );
  }

  factory BulkQuote.fromJson(Map<String, dynamic> json) {
    return BulkQuote(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productTitle: json['productTitle'] as String? ?? '',
      buyerName: json['buyerName'] as String? ?? '',
      buyerOrg: json['buyerOrg'] as String? ?? '',
      requestedQuantity: (json['requestedQuantity'] as num?)?.toInt() ?? 1,
      targetPricePerUnit: (json['targetPricePerUnit'] as num?)?.toDouble() ?? 0.0,
      artisanCounterPrice: json['artisanCounterPrice'] as String?,
      status: json['status'] as String? ?? 'pending',
      requestedAt: json['requestedAt'] != null
          ? DateTime.tryParse(json['requestedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productTitle': productTitle,
      'buyerName': buyerName,
      'buyerOrg': buyerOrg,
      'requestedQuantity': requestedQuantity,
      'targetPricePerUnit': targetPricePerUnit,
      'artisanCounterPrice': artisanCounterPrice,
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        productTitle,
        buyerName,
        buyerOrg,
        requestedQuantity,
        targetPricePerUnit,
        artisanCounterPrice,
        status,
        requestedAt,
        notes,
      ];
}

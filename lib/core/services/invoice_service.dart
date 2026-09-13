class HandloomInvoice {
  final String invoiceNumber;
  final String orderId;
  final String buyerName;
  final String buyerOrg;
  final String artisanName;
  final String clusterName;
  final String productTitle;
  final String hsnCode;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double gstRate; // 0.0% for certified GI Handloom under MoSJE exemption
  final double totalAmount;
  final String dbtEscrowRef;
  final DateTime issuedAt;
  final String eWayBillNumber;

  const HandloomInvoice({
    required this.invoiceNumber,
    required this.orderId,
    required this.buyerName,
    required this.buyerOrg,
    required this.artisanName,
    required this.clusterName,
    required this.productTitle,
    required this.hsnCode,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.gstRate,
    required this.totalAmount,
    required this.dbtEscrowRef,
    required this.issuedAt,
    required this.eWayBillNumber,
  });
}

class InvoiceService {
  static HandloomInvoice generateInvoiceForOrder({
    required String orderId,
    required String productTitle,
    required double totalPrice,
    required String buyerName,
    String? buyerOrg,
  }) {
    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');

    // Determine HSN code based on craft type
    String hsn = 'HSN 5007'; // Handloom silk
    if (productTitle.toLowerCase().contains('pottery') || productTitle.toLowerCase().contains('bowl')) {
      hsn = 'HSN 6912'; // Terracotta and ceramic tableware
    } else if (productTitle.toLowerCase().contains('painting') || productTitle.toLowerCase().contains('art')) {
      hsn = 'HSN 9701'; // Original folk art and paintings
    }

    return HandloomInvoice(
      invoiceNumber: 'INV-MOSJE-2026-$randomSuffix',
      orderId: orderId,
      buyerName: buyerName,
      buyerOrg: buyerOrg ?? 'Verified Retail Buyer',
      artisanName: 'Ramdev Varma (Master Craftsman)',
      clusterName: 'Varanasi Mulberry Silk Weaving Guild (Cluster #04)',
      productTitle: productTitle,
      hsnCode: hsn,
      quantity: 1,
      unitPrice: totalPrice,
      subtotal: totalPrice,
      gstRate: 0.0, // Handloom GI exemption
      totalAmount: totalPrice,
      dbtEscrowRef: 'DBT-SBI-ESCROW-2026-$randomSuffix',
      issuedAt: now,
      eWayBillNumber: 'EWB-9012-4821-$randomSuffix',
    );
  }
}

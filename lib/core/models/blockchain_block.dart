class BlockchainTransaction {
  final String txHash;
  final String type;
  final String fromAddress;
  final String toAddress;
  final double amountInr;
  final String craftId;
  final String payloadSummary;
  final DateTime timestamp;
  final String status;

  const BlockchainTransaction({
    required this.txHash,
    required this.type,
    required this.fromAddress,
    required this.toAddress,
    this.amountInr = 0.0,
    required this.craftId,
    required this.payloadSummary,
    required this.timestamp,
    this.status = 'Confirmed',
  });

  factory BlockchainTransaction.fromJson(Map<String, dynamic> json) {
    return BlockchainTransaction(
      txHash: json['txHash'] ?? '',
      type: json['type'] ?? '',
      fromAddress: json['fromAddress'] ?? '',
      toAddress: json['toAddress'] ?? '',
      amountInr: (json['amountInr'] as num?)?.toDouble() ?? 0.0,
      craftId: json['craftId'] ?? '',
      payloadSummary: json['payloadSummary'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] ?? 'Confirmed',
    );
  }

  Map<String, dynamic> toJson() => {
        'txHash': txHash,
        'type': type,
        'fromAddress': fromAddress,
        'toAddress': toAddress,
        'amountInr': amountInr,
        'craftId': craftId,
        'payloadSummary': payloadSummary,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
      };
}

class BlockchainBlock {
  final int blockNumber;
  final String blockHash;
  final String previousHash;
  final String merkleRoot;
  final DateTime timestamp;
  final String validator;
  final int gasUsed;
  final List<BlockchainTransaction> transactions;

  const BlockchainBlock({
    required this.blockNumber,
    required this.blockHash,
    required this.previousHash,
    required this.merkleRoot,
    required this.timestamp,
    required this.validator,
    required this.gasUsed,
    required this.transactions,
  });

  factory BlockchainBlock.fromJson(Map<String, dynamic> json) {
    return BlockchainBlock(
      blockNumber: (json['blockNumber'] as num?)?.toInt() ?? 0,
      blockHash: json['blockHash'] ?? '',
      previousHash: json['previousHash'] ?? '',
      merkleRoot: json['merkleRoot'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      validator: json['validator'] ?? 'MoSJE Sovereign Validator Node #1',
      gasUsed: (json['gasUsed'] as num?)?.toInt() ?? 21000,
      transactions: (json['transactions'] as List?)
              ?.map((t) => BlockchainTransaction.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'blockNumber': blockNumber,
        'blockHash': blockHash,
        'previousHash': previousHash,
        'merkleRoot': merkleRoot,
        'timestamp': timestamp.toIso8601String(),
        'validator': validator,
        'gasUsed': gasUsed,
        'transactions': transactions.map((t) => t.toJson()).toList(),
      };

  static List<BlockchainBlock> getSeedBlocks() {
    final now = DateTime.now();
    return [
      BlockchainBlock(
        blockNumber: 1045,
        blockHash: '0x9e12b7c4a6d8f0e2b4c6a8e0d2f4b6a8c0e2d4f6a8b0c2e4d6f8a0b2c4e6f8a0',
        previousHash: '0x5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d',
        merkleRoot: '0xfe492a819b4c2e6d8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f',
        timestamp: now.subtract(const Duration(minutes: 12)),
        validator: 'MoSJE Sovereign Validator Node #1 (Varanasi)',
        gasUsed: 42190,
        transactions: [
          BlockchainTransaction(
            txHash: '0x9e12b7...3b92',
            type: 'PFMS_PAYOUT_RELEASE',
            fromAddress: '0x3a4b...escrow_vault',
            toAddress: '0x712a...sbi_artisan_4819',
            amountInr: 8500.0,
            craftId: 'prod_01',
            payloadSummary: 'SBI DBT Direct Credit for Order #ORD-2026-9041 released via PFMS callback',
            timestamp: now.subtract(const Duration(minutes: 12)),
          ),
        ],
      ),
      BlockchainBlock(
        blockNumber: 1044,
        blockHash: '0x5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d',
        previousHash: '0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02',
        merkleRoot: '0x83b2d1f46a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c',
        timestamp: now.subtract(const Duration(hours: 3)),
        validator: 'MoSJE Sovereign Validator Node #2 (New Delhi)',
        gasUsed: 65430,
        transactions: [
          BlockchainTransaction(
            txHash: '0x5d2e7a...9041',
            type: 'SMART_ESCROW_LOCK',
            fromAddress: '0x8b3c...buyer_wallet',
            toAddress: '0x3a4b...escrow_vault',
            amountInr: 8500.0,
            craftId: 'prod_01',
            payloadSummary: 'Locked ₹8,500 in Polygon-compatible Escrow Smart Contract pending delivery QR verification',
            timestamp: now.subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      BlockchainBlock(
        blockNumber: 1043,
        blockHash: '0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02',
        previousHash: '0x4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a',
        merkleRoot: '0x19a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02384a9',
        timestamp: now.subtract(const Duration(days: 1)),
        validator: 'MoSJE Sovereign Validator Node #1 (Varanasi)',
        gasUsed: 98210,
        transactions: [
          BlockchainTransaction(
            txHash: '0x8f3c7b...259d',
            type: 'GI_CRAFT_MINT',
            fromAddress: '0x0000...mint_contract',
            toAddress: '0x712a...master_ramdev',
            amountInr: 8500.0,
            craftId: 'prod_01',
            payloadSummary: 'Minted Digital Craft Passport GI-IN-UP-2024-VARANASI-089 (Banarasi Katan Silk Handloom Saree)',
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
      BlockchainBlock(
        blockNumber: 1042,
        blockHash: '0x4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a',
        previousHash: '0x0000000000000000000000000000000000000000000000000000000000000000',
        merkleRoot: '0x7b1c3d5e7a9f1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c5e7b9d1f3a5c7e9b1d',
        timestamp: now.subtract(const Duration(days: 30)),
        validator: 'MoSJE Genesis Sovereign Authority (MeitY/NIC)',
        gasUsed: 21000,
        transactions: [
          BlockchainTransaction(
            txHash: '0x4a9b2c...0000',
            type: 'GENESIS',
            fromAddress: '0x0000000000000000000000000000000000000000',
            toAddress: '0xmosje...national_registry',
            amountInr: 0.0,
            craftId: 'SYSTEM',
            payloadSummary: 'MoSJE Sovereign Proof-of-Authority (PoA) Consortium Genesis Block initialized',
            timestamp: now.subtract(const Duration(days: 30)),
          ),
        ],
      ),
    ];
  }
}

class CraftProvenance {
  final String productId;
  final String giRegistryCode;
  final String cryptographicHash;
  final String clusterName;
  final String gpsCoordinates;
  final String rawMaterialOrigin;
  final String weaverMasterName;
  final String weaverAadhaarHash;
  final String loomTypeId;
  final DateTime weaveStartDate;
  final DateTime inspectionDate;
  final int qualityInspectionScore;
  final String mosjeVerifierOfficer;

  const CraftProvenance({
    required this.productId,
    required this.giRegistryCode,
    required this.cryptographicHash,
    required this.clusterName,
    required this.gpsCoordinates,
    required this.rawMaterialOrigin,
    required this.weaverMasterName,
    required this.weaverAadhaarHash,
    required this.loomTypeId,
    required this.weaveStartDate,
    required this.inspectionDate,
    required this.qualityInspectionScore,
    required this.mosjeVerifierOfficer,
  });
}

class ProvenanceService {
  static CraftProvenance getProvenanceForProduct(String productId) {
    return CraftProvenance(
      productId: productId,
      giRegistryCode: 'GI-IN-UP-2024-VARANASI-089',
      cryptographicHash: '0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a',
      clusterName: 'Varanasi Mulberry Silk Weaving Guild (Cluster #04)',
      gpsCoordinates: '25.3176° N, 82.9739° E (Varanasi, UP)',
      rawMaterialOrigin: 'Sericulture Silk Board, Malda & Degummed Zari Mills, Surat',
      weaverMasterName: 'Ramdev Varma (Master Craftsman ID: PMV-78401)',
      weaverAadhaarHash: 'XXXX-XXXX-9012 (DBT Verified)',
      loomTypeId: 'Traditional Pit Loom with Jacquard Harness #PL-22',
      weaveStartDate: DateTime.now().subtract(const Duration(days: 14)),
      inspectionDate: DateTime.now().subtract(const Duration(days: 1)),
      qualityInspectionScore: 98,
      mosjeVerifierOfficer: 'Dr. Anand Swaroop (MoSJE Zonal Director)',
    );
  }
}

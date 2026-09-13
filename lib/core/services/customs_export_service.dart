class ExportClearanceDocument {
  final String exportDocNumber;
  final String dgftCertificateNumber;
  final String portOfLoading;
  final String destinationCountry;
  final String exporterName;
  final String exporterIecCode;
  final String craftHsCode;
  final String craftDescription;
  final String giProvenanceHash;
  final double invoiceFobValueUsd;
  final String customsOfficerSeal;
  final DateTime clearanceDate;

  const ExportClearanceDocument({
    required this.exportDocNumber,
    required this.dgftCertificateNumber,
    required this.portOfLoading,
    required this.destinationCountry,
    required this.exporterName,
    required this.exporterIecCode,
    required this.craftHsCode,
    required this.craftDescription,
    required this.giProvenanceHash,
    required this.invoiceFobValueUsd,
    required this.customsOfficerSeal,
    required this.clearanceDate,
  });
}

class CustomsExportService {
  static ExportClearanceDocument generateClearance({
    required String productTitle,
    required double priceInr,
    required String destinationCountry,
  }) {
    final now = DateTime.now();
    final randomSuffix = (now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
    final fobUsd = priceInr / 86.50;

    return ExportClearanceDocument(
      exportDocNumber: 'IN-PBE-III-2026-$randomSuffix',
      dgftCertificateNumber: 'DGFT-COO-NP-2026-$randomSuffix',
      portOfLoading: 'Air Cargo Complex (IGI Airport, New Delhi / DEL)',
      destinationCountry: destinationCountry,
      exporterName: 'Varanasi Mulberry Silk Weaving Guild (MoSJE Cluster Hub #04)',
      exporterIecCode: 'IEC-0520260901',
      craftHsCode: 'HS 5007.20.10 (Handloom Silk)',
      craftDescription: productTitle,
      giProvenanceHash: '0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a',
      invoiceFobValueUsd: fobUsd,
      customsOfficerSeal: 'Inspector Rajeshwar Rao (Indian Customs Postal Appraising Department)',
      clearanceDate: now,
    );
  }
}

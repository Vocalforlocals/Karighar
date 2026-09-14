import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/provenance_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class CraftPassportScreen extends StatelessWidget {
  final String productId;
  const CraftPassportScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final provenance = ProvenanceService.getProvenanceForProduct(productId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cryptographic Verification Header
            VKCard(
              color: AppColors.tealLight.withValues(alpha: 0.4),
              borderColor: AppColors.teal.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                            child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('100% VERIFIED GI CRAFT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.tealDark)),
                              Text('Ministry of Social Justice & Empowerment', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                      const VKBadge(label: 'AUTHENTIC', type: VKBadgeType.verified),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text('Cryptographic SHA-256 Provenance Hash:', style: TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.cardBorder)),
                    child: Text(
                      provenance.cryptographicHash,
                      style: GoogleFonts.firaCode(fontSize: 10, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Realistic Passport Document Card
            VKCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NATIONAL ARTISAN REGISTRY',
                        style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppColors.saffronDark),
                      ),
                      Text('Reg: ${provenance.giRegistryCode}', style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 18),

                  _buildDetailRow('Master Craftsman', provenance.weaverMasterName),
                  _buildDetailRow('Aadhaar / DBT Hash', provenance.weaverAadhaarHash),
                  _buildDetailRow('Loom Cluster Hub', provenance.clusterName),
                  _buildDetailRow('Loom GPS Geolocation', provenance.gpsCoordinates),
                  _buildDetailRow('Loom Type / Rig', provenance.loomTypeId),
                  _buildDetailRow('Raw Material Source', provenance.rawMaterialOrigin),
                  _buildDetailRow('Weaving Duration', '14 Days (Handwoven pit loom)'),
                  _buildDetailRow('Inspection Score', '${provenance.qualityInspectionScore}/100 (Graded by ${provenance.mosjeVerifierOfficer})'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tamper-Evident QR Code Display
            VKCard(
              child: Center(
                child: Column(
                  children: [
                    const Text('Scan to Verify on MoSJE Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: const Icon(Icons.qr_code_2_rounded, size: 140, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan this code from packaging box to confirm zero-middlemen direct DBT provenance.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            VKButton(
              label: '⛓️ Verify on Sovereign Blockchain Ledger',
              width: double.infinity,
              onPressed: () => context.push('/buyer/ledger?q=${provenance.productId}'),
            ),

          ],
        ),
      ),
    );
  }


  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

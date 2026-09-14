import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/currency_service.dart';
import '../../../core/services/customs_export_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_button.dart';
import '../../../core/widgets/vk_card.dart';

class ExportCustomsScreen extends StatefulWidget {
  final String productTitle;
  final double priceInr;

  const ExportCustomsScreen({
    super.key,
    this.productTitle = 'Banarasi Katan Silk Handloom Saree',
    this.priceInr = 8500.0,
  });

  @override
  State<ExportCustomsScreen> createState() => _ExportCustomsScreenState();
}

class _ExportCustomsScreenState extends State<ExportCustomsScreen> {
  String _selectedCountry = 'United States (USA)';
  late ExportClearanceDocument _doc;

  @override
  void initState() {
    super.initState();
    _doc = CustomsExportService.generateClearance(
      productTitle: widget.productTitle,
      priceInr: widget.priceInr,
      destinationCountry: _selectedCountry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Selector Banner
            VKCard(
              color: const Color(0xFF0F172A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Destination Country for Cross-Border Dispatch:', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCountry,
                    dropdownColor: const Color(0xFF1E293B),
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      'United States (USA)',
                      'United Kingdom (UK)',
                      'Germany (EU)',
                      'United Arab Emirates (UAE)',
                      'Japan (JP)',
                    ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCountry = val;
                          _doc = CustomsExportService.generateClearance(
                            productTitle: widget.productTitle,
                            priceInr: widget.priceInr,
                            destinationCountry: _selectedCountry,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Declared Value (USD):', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                      Text(
                        CurrencyService.formatCurrency(widget.priceInr, 'USD'),
                        style: const TextStyle(color: AppColors.teal, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Certificate Document Card
            VKCard(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GOVERNMENT OF INDIA',
                            style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppColors.textPrimary),
                          ),
                          const Text('Directorate General of Foreign Trade (DGFT)', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          const Text('Certificate of Origin (Non-Preferential)', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const VKBadge(label: 'EXPORT READY', type: VKBadgeType.verified),
                    ],
                  ),
                  const Divider(height: 20),

                  _buildField('Certificate No:', _doc.dgftCertificateNumber),
                  _buildField('Postal Bill of Export:', _doc.exportDocNumber),
                  _buildField('Port of Loading:', _doc.portOfLoading),
                  _buildField('Destination Country:', _doc.destinationCountry),
                  _buildField('Exporter (Cluster Hub):', _doc.exporterName),
                  _buildField('Exporter IEC Code:', _doc.exporterIecCode),
                  _buildField('Harmonized System (HS):', _doc.craftHsCode),
                  _buildField('Craft Item:', _doc.craftDescription),
                  _buildField('GI Provenance Hash:', _doc.giProvenanceHash),
                  _buildField('Clearance Officer:', _doc.customsOfficerSeal),
                  const Divider(height: 16),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.tealLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        Icon(Icons.flight_takeoff_rounded, color: AppColors.teal, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Air freight customs manifest dispatched to India Post International Hub & DHL Express.',
                            style: TextStyle(fontSize: 10, color: AppColors.tealDark, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: VKButton(
                    label: 'India Post / DHL Pickup',
                    icon: Icons.local_shipping_outlined,
                    variant: VKButtonVariant.secondary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('International courier dispatch request confirmed! Tracking ID: IN-POST-90214'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: VKButton(
                    label: 'Download COO (PDF)',
                    icon: Icons.download_rounded,
                    variant: VKButtonVariant.primary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('DGFT Export Certificate of Origin downloaded successfully!'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/blockchain_block.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';
import '../../../core/widgets/vk_badge.dart';
import '../../../core/widgets/vk_card.dart';

class BlockchainExplorerScreen extends StatefulWidget {
  final String? initialSearch;
  const BlockchainExplorerScreen({super.key, this.initialSearch});

  @override
  State<BlockchainExplorerScreen> createState() => _BlockchainExplorerScreenState();
}

class _BlockchainExplorerScreenState extends State<BlockchainExplorerScreen> {
  List<BlockchainBlock> _blocks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  BlockchainBlock? _selectedBlock;

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _searchQuery = widget.initialSearch!;
      _searchController.text = widget.initialSearch!;
    }
    _loadBlocks();
  }

  Future<void> _loadBlocks() async {
    setState(() => _isLoading = true);
    final blocks = await ApiClient.getBlockchainBlocks();
    if (!mounted) return;
    setState(() {
      _blocks = blocks;
      _isLoading = false;
      if (_blocks.isNotEmpty) {
        _selectedBlock = _blocks.first;
      }
    });
  }

  List<BlockchainBlock> get _filteredBlocks {
    if (_searchQuery.trim().isEmpty) return _blocks;
    final q = _searchQuery.toLowerCase().trim();
    return _blocks.where((b) {
      final matchesNumber = b.blockNumber.toString().contains(q);
      final matchesHash = b.blockHash.toLowerCase().contains(q);
      final matchesTx = b.transactions.any((tx) =>
          tx.txHash.toLowerCase().contains(q) ||
          tx.craftId.toLowerCase().contains(q) ||
          tx.type.toLowerCase().contains(q) ||
          tx.payloadSummary.toLowerCase().contains(q));
      return matchesNumber || matchesHash || matchesTx;
    }).toList();
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'GENESIS':
        return Colors.purple;
      case 'GI_CRAFT_MINT':
        return AppColors.teal;
      case 'SMART_ESCROW_LOCK':
        return AppColors.saffron;
      case 'PFMS_PAYOUT_RELEASE':
        return Colors.green.shade700;
      default:
        return AppColors.tealDark;
    }
  }

  void _showMerkleProofDialog(BuildContext context, BlockchainBlock block) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.verified_user_rounded, color: Colors.green.shade700, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Cryptographic Merkle Proof',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Block Header Merkle Root (SHA-256):',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                block.merkleRoot,
                style: GoogleFonts.firaCode(fontSize: 10, color: AppColors.tealDark),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Validator Proof-of-Authority Signature:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                block.validator,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'Consensus Verified: 4/4 Zonal Nodes Signed',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'Blockchain Ledger Explorer',
        showBackButton: true,
        currentRole: 'buyer',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.teal))
          : RefreshIndicator(
              onRefresh: _loadBlocks,
              color: AppColors.teal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Network Status Header Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.tealDark, AppColors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tealDark.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'MoSJE Sovereign Consortium Subnet',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Chain ID: 13702',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Decentralized Proof-of-Authority (PoA) ledger guaranteeing cryptographic GI provenance, smart contract escrow states, and direct DBT disbursements.',
                            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildMetricItem('BLOCK HEIGHT', '#1045'),
                              _buildMetricItem('BLOCK TIME', '2.1s'),
                              _buildMetricItem('VALIDATORS', '4 Zonal Nodes'),
                              _buildMetricItem('FINALITY', 'Instant'),
                            ],
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Search & Filter Box
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search by Block #, Tx Hash, Craft ID, or GI Registry Code...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textLight),
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.teal),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Block Chain Interactive Ribbon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '⛓️ Immutable Block Chain',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          '${_blocks.length} Blocks Verified',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 115,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _blocks.length,
                        separatorBuilder: (ctx, idx) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(Icons.link_rounded, color: AppColors.teal.withValues(alpha: 0.6), size: 22),
                          ),
                        ),
                        itemBuilder: (ctx, idx) {
                          final block = _blocks[idx];
                          final isSelected = _selectedBlock?.blockNumber == block.blockNumber;
                          return InkWell(
                            onTap: () => setState(() => _selectedBlock = block),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 195,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.saffron : AppColors.cardBorder,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.saffron.withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Block #${block.blockNumber}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: isSelected ? AppColors.saffronDark : AppColors.tealDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      VKBadge(
                                        label: '${block.transactions.length} Tx',
                                        type: VKBadgeType.info,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    block.blockHash,
                                    style: GoogleFonts.firaCode(fontSize: 9, color: AppColors.textSecondary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${block.gasUsed} gas',
                                        style: const TextStyle(fontSize: 9, color: AppColors.textLight),
                                      ),
                                      const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textLight),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Selected Block Detail Inspector
                    if (_selectedBlock != null) ...[
                      VKCard(
                        borderColor: AppColors.teal.withValues(alpha: 0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Block #${_selectedBlock!.blockNumber} Details',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.tealDark),
                                ),
                                InkWell(
                                  onTap: () => _showMerkleProofDialog(context, _selectedBlock!),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.green.shade300),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.shield_rounded, size: 12, color: Colors.green.shade700),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Verify Merkle Proof',
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            _buildHashRow('Block Hash:', _selectedBlock!.blockHash),
                            const SizedBox(height: 6),
                            _buildHashRow('Previous Hash:', _selectedBlock!.previousHash),
                            const SizedBox(height: 6),
                            _buildHashRow('Merkle Root:', _selectedBlock!.merkleRoot),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Validator: ${_selectedBlock!.validator}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                ),
                                Text(
                                  'Gas: ${_selectedBlock!.gasUsed}',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Transactions Table Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '📜 Confirmed Transactions',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          '${_filteredBlocks.fold(0, (sum, b) => sum + b.transactions.length)} Transactions Found',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Transactions List
                    if (_filteredBlocks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No transactions match your search query.',
                            style: TextStyle(color: AppColors.textLight, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ..._filteredBlocks.expand((block) => block.transactions.map((tx) {
                            final txColor = _getTransactionColor(tx.type);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: VKCard(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: txColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: txColor.withValues(alpha: 0.3)),
                                          ),
                                          child: Text(
                                            tx.type,
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: txColor),
                                          ),
                                        ),
                                        if (tx.amountInr > 0)
                                          Text(
                                            '₹${tx.amountInr.toStringAsFixed(0)}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.saffronDark),
                                          )
                                        else
                                          const Text(
                                            'MINT / STATE',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      tx.payloadSummary,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text('Tx Hash: ', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                        Expanded(
                                          child: Text(
                                            tx.txHash,
                                            style: GoogleFonts.firaCode(fontSize: 10, color: AppColors.tealDark),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 4,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('From: ', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                            Text(tx.fromAddress, style: GoogleFonts.firaCode(fontSize: 10, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('➔ To: ', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                            Text(tx.toAddress, style: GoogleFonts.firaCode(fontSize: 10, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),

                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white60, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHashRow(String label, String hash) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Text(
            hash,
            style: GoogleFonts.firaCode(fontSize: 9.5, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/chat_negotiation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_conversational_mic.dart';
import '../bloc/artisan_bloc.dart';

class ArtisanQuotesScreen extends StatefulWidget {
  const ArtisanQuotesScreen({super.key});

  @override
  State<ArtisanQuotesScreen> createState() => _ArtisanQuotesScreenState();
}

class _ArtisanQuotesScreenState extends State<ArtisanQuotesScreen> {
  String? _selectedThreadId;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final threads = ChatNegotiationService.instance.threads;
    if (threads.isNotEmpty) {
      _selectedThreadId = threads.first.id;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(ChatThread thread, {String? textOverride, bool isAi = false}) {
    final text = (textOverride ?? _textController.text).trim();
    if (text.isEmpty) return;

    final artisanName = ApiClient.currentUser?.fullName.isNotEmpty == true
        ? ApiClient.currentUser!.fullName
        : 'Master Artisan';

    ChatNegotiationService.instance.sendMessage(
      threadId: thread.id,
      senderRole: 'artisan',
      senderName: artisanName,
      text: text,
      isAiAssisted: isAi,
    );

    if (textOverride == null) {
      _textController.clear();
    }
    _scrollToBottom();
  }

  void _handleAcceptOffer(ChatThread thread) {
    final artisanName = ApiClient.currentUser?.fullName.isNotEmpty == true
        ? ApiClient.currentUser!.fullName
        : 'Master Artisan';

    ChatNegotiationService.instance.acceptOffer(
      threadId: thread.id,
      senderRole: 'artisan',
      senderName: artisanName,
    );

    // Sync with ArtisanBloc quote state if quoteId exists
    if (thread.quoteId.isNotEmpty) {
      context.read<ArtisanBloc>().add(RespondToQuoteEvent(
            quoteId: thread.quoteId,
            responseStatus: 'accepted',
          ));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Deal accepted with ${thread.buyerOrg}! Advance locked in Escrow.'),
        backgroundColor: AppColors.teal,
      ),
    );
    _scrollToBottom();
  }

  void _showCounterOfferDialog(BuildContext context, ChatThread thread) {
    final qty = thread.requestedQuantity;
    final currentTarget = thread.targetPricePerUnit;
    double counterVal = currentTarget * 1.08; // default +8%
    final priceController = TextEditingController(text: counterVal.toStringAsFixed(0));
    final noteController = TextEditingController(text: 'Includes 100% Handloom GI Certification & wooden loom packing.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final parsedPrice = double.tryParse(priceController.text) ?? counterVal;
            final totalCounter = parsedPrice * qty;

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.terracottaLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.handshake_rounded, color: AppColors.terracotta, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Send Counter-Offer to Buyer', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('${thread.buyerOrg} • $qty units requested', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Buyer Offered Price', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text('₹${currentTarget.toStringAsFixed(0)} / unit', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.textLight, size: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Proposed Deal Total', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                          Text('₹${totalCounter.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.saffronDark)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Your Counter Unit Price (₹)', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setModalState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.currency_rupee, color: AppColors.terracotta, size: 18),
                      hintText: 'Enter unit price',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Quick percentage adjustment pills
                  Row(
                    children: [
                      const Text('Quick Presets: ', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      _presetChip('+5%', currentTarget * 1.05, priceController, setModalState),
                      const SizedBox(width: 6),
                      _presetChip('+10%', currentTarget * 1.10, priceController, setModalState),
                      const SizedBox(width: 6),
                      _presetChip('+15%', currentTarget * 1.15, priceController, setModalState),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('Reason / Note to Buyer', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'e.g. Includes silk mark seal, natural dye verification',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.terracotta,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: Text('Send Counter-Offer (₹${totalCounter.toStringAsFixed(0)})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      onPressed: () {
                        final finalUnit = double.tryParse(priceController.text) ?? counterVal;
                        final explanation = noteController.text.trim();
                        final artisanName = ApiClient.currentUser?.fullName.isNotEmpty == true
                            ? ApiClient.currentUser!.fullName
                            : 'Master Artisan';

                        ChatNegotiationService.instance.sendCounterOffer(
                          threadId: thread.id,
                          senderRole: 'artisan',
                          senderName: artisanName,
                          counterPrice: finalUnit,
                          explanation: explanation,
                        );

                        if (thread.quoteId.isNotEmpty) {
                          context.read<ArtisanBloc>().add(RespondToQuoteEvent(
                                quoteId: thread.quoteId,
                                responseStatus: 'countered',
                                counterPrice: '₹${finalUnit.toStringAsFixed(0)} / unit ($explanation)',
                              ));
                        }

                        Navigator.pop(ctx);
                        _scrollToBottom();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Counter offer sent to ${thread.buyerOrg}!'), backgroundColor: AppColors.teal),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _presetChip(String label, double val, TextEditingController controller, StateSetter setModalState) {
    return InkWell(
      onTap: () {
        setModalState(() {
          controller.text = val.toStringAsFixed(0);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.terracottaLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.terracotta.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.terracotta)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: ChatNegotiationService.instance,
        builder: (context, _) {
          final threads = ChatNegotiationService.instance.threads;
          if (threads.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.textLight),
                  const SizedBox(height: 12),
                  Text('No buyer negotiations yet'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('When buyers submit RFPs or inquiries, you can chat and negotiate directly here.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            );
          }

          final activeThread = threads.firstWhere(
            (t) => t.id == _selectedThreadId,
            orElse: () => threads.first,
          );

          if (isDesktop) {
            // DESKTOP SPLIT VIEW
            return Row(
              children: [
                // Left Thread List (320px)
                Container(
                  width: 320,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(right: BorderSide(color: AppColors.cardBorder)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.chat_rounded, color: AppColors.terracotta, size: 20),
                            const SizedBox(width: 8),
                            Text('Buyer Negotiations', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.terracottaLight, borderRadius: BorderRadius.circular(10)),
                              child: Text('${threads.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.terracotta)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: threads.length,
                          separatorBuilder: (ctx, idx) => const Divider(height: 1, color: AppColors.divider),
                          itemBuilder: (ctx, idx) {
                            final t = threads[idx];
                            final isSelected = t.id == activeThread.id;
                            return _buildThreadTile(t, isSelected);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Chat Panel
                Expanded(
                  child: _buildChatPanel(context, activeThread),
                ),
              ],
            );
          } else {
            // MOBILE ADAPTIVE VIEW
            return Column(
              children: [
                // Top Thread Strip (Easy 1-tap switching between buyers!)
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: threads.length,
                    separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                    itemBuilder: (ctx, idx) {
                      final t = threads[idx];
                      final isSelected = t.id == activeThread.id;
                      return InkWell(
                        onTap: () {
                          setState(() => _selectedThreadId = t.id);
                          ChatNegotiationService.instance.markAsRead(t.id, 'artisan');
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.terracotta : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.terracotta : AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Text(
                                t.buyerOrg.length > 15 ? '${t.buyerOrg.substring(0, 15)}...' : t.buyerOrg,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              if (t.unreadCountArtisan > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Active Chat Body
                Expanded(
                  child: _buildChatPanel(context, activeThread),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildThreadTile(ChatThread t, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() => _selectedThreadId = t.id);
        ChatNegotiationService.instance.markAsRead(t.id, 'artisan');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: isSelected ? AppColors.terracottaLight.withValues(alpha: 0.4) : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(t.buyerOrg, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                _buildStatusPill(t.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(t.productTitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${t.targetPricePerUnit.toStringAsFixed(0)}/u • ${t.requestedQuantity} pcs', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                if (t.unreadCountArtisan > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.terracotta, borderRadius: BorderRadius.circular(8)),
                    child: Text('${t.unreadCountArtisan} new', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = AppColors.background;
    Color fg = AppColors.textSecondary;
    String label = status.toUpperCase();

    if (status == 'accepted') {
      bg = AppColors.tealLight;
      fg = AppColors.tealDark;
      label = 'ACCEPTED';
    } else if (status == 'countered') {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
      label = 'COUNTERED';
    } else {
      bg = const Color(0xFFEFF6FF);
      fg = const Color(0xFF1D4ED8);
      label = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildChatPanel(BuildContext context, ChatThread thread) {
    return Column(
      children: [
        // Top Sticky Deal Negotiation Card
        _buildStickyDealCard(context, thread),

        // Message Stream
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: thread.messages.length,
            itemBuilder: (context, idx) {
              final msg = thread.messages[idx];
              return _buildMessageBubble(context, msg, thread);
            },
          ),
        ),

        // Quick Reply Suggestions (Tap to send in 1 touch!)
        _buildQuickReplies(thread),

        // Chat Input Bar
        _buildInputBar(context, thread),
      ],
    );
  }

  Widget _buildStickyDealCard(BuildContext context, ChatThread thread) {
    final total = thread.requestedQuantity * thread.targetPricePerUnit;
    final isAccepted = thread.status == 'accepted';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(thread.buyerOrg, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13.5)),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, color: AppColors.teal, size: 14),
                      ],
                    ),
                    Text('${thread.buyerName} • ${thread.productTitle}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${total.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.saffronDark)),
                  Text('${thread.requestedQuantity} pcs @ ₹${thread.targetPricePerUnit.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10.5, color: AppColors.textLight)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Action Buttons Bar
          Row(
            children: [
              if (!isAccepted) ...[
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
                      label: const Text('Accept Offer', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      onPressed: () => _handleAcceptOffer(thread),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.terracotta, width: 1.2),
                        foregroundColor: AppColors.terracotta,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.edit_note_rounded, size: 16),
                      label: const Text('Counter Offer', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      onPressed: () => _showCounterOfferDialog(context, thread),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.tealLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.teal.withValues(alpha: 0.3)),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_rounded, size: 14, color: AppColors.tealDark),
                          SizedBox(width: 6),
                          Text('Order Locked & Escrow Advance Active', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, NegotiationChatMessage msg, ChatThread thread) {
    final isMe = msg.senderRole == 'artisan';
    final isSystem = msg.senderRole == 'system';

    if (isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, size: 14, color: AppColors.royalIndigo),
                  const SizedBox(width: 6),
                  Text(msg.senderName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.royalIndigo)),
                ],
              ),
              const SizedBox(height: 4),
              Text(msg.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (MediaQuery.of(context).size.width > 800 ? 0.6 : 0.82)),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.terracotta : AppColors.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isMe ? const Radius.circular(2) : const Radius.circular(16),
            bottomLeft: !isMe ? const Radius.circular(2) : const Radius.circular(16),
          ),
          border: Border.all(color: isMe ? Colors.transparent : AppColors.cardBorder),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(msg.senderName, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
              const SizedBox(height: 4),
            ],
            Text(
              msg.text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: isMe ? Colors.white : AppColors.textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 9, color: isMe ? Colors.white70 : AppColors.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies(ChatThread thread) {
    final suggestions = [
      '🧵 Can start loom production tomorrow',
      '🏅 100% Silk Mark & GI Tag included',
      '📦 Ready to dispatch swatch sample',
      '📅 Guaranteed delivery in 25 days',
    ];

    return Container(
      height: 36,
      margin: const EdgeInsets.only(bottom: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: suggestions.length,
        separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
        itemBuilder: (ctx, idx) {
          final s = suggestions[idx];
          return InkWell(
            onTap: () => _handleSendMessage(thread, textOverride: s),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Text(s, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatThread thread) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (_) => _handleSendMessage(thread),
                decoration: InputDecoration(
                  hintText: 'Type reply or negotiate...'.tr,
                  hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                  filled: true,
                  fillColor: AppColors.background,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.cardBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.cardBorder)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.mic_rounded, color: AppColors.terracotta, size: 22),
              tooltip: 'Bhashini Voice Input',
              onPressed: () => VKConversationalMic.showSetuDidiVoiceSheet(context),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _handleSendMessage(thread),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: AppColors.terracotta, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/chat_negotiation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_conversational_mic.dart';

class BuyerQuotesScreen extends StatefulWidget {
  const BuyerQuotesScreen({super.key});

  @override
  State<BuyerQuotesScreen> createState() => _BuyerQuotesScreenState();
}

class _BuyerQuotesScreenState extends State<BuyerQuotesScreen> {
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

  void _handleSendMessage(ChatThread thread, {String? textOverride}) {
    final text = (textOverride ?? _textController.text).trim();
    if (text.isEmpty) return;

    final buyerName = ApiClient.currentUser?.fullName.isNotEmpty == true
        ? ApiClient.currentUser!.fullName
        : 'Buyer';

    ChatNegotiationService.instance.sendMessage(
      threadId: thread.id,
      senderRole: 'buyer',
      senderName: buyerName,
      text: text,
    );

    if (textOverride == null) {
      _textController.clear();
    }
    _scrollToBottom();
  }

  void _handleAcceptCounter(ChatThread thread) {
    final buyerName = ApiClient.currentUser?.fullName.isNotEmpty == true
        ? ApiClient.currentUser!.fullName
        : 'Buyer';

    ChatNegotiationService.instance.acceptOffer(
      threadId: thread.id,
      senderRole: 'buyer',
      senderName: buyerName,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Counter offer accepted! Order locked with ${thread.artisanName}.'),
        backgroundColor: AppColors.teal,
      ),
    );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.forum_outlined, size: 48, color: AppColors.textLight),
                  const SizedBox(height: 12),
                  Text('No active artisan chats yet'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Request a custom quote from any craft product page to chat directly with master artisans.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            );
          }

          final activeThread = threads.firstWhere(
            (t) => t.id == _selectedThreadId,
            orElse: () => threads.first,
          );

          return Column(
            children: [
              // Top Artisan Thread Strip
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
                        ChatNegotiationService.instance.markAsRead(t.id, 'buyer');
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
                              t.artisanName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            if (t.unreadCountBuyer > 0) ...[
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
        },
      ),
    );
  }

  Widget _buildChatPanel(BuildContext context, ChatThread thread) {
    return Column(
      children: [
        // Top Sticky Deal Card
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

        // Quick Reply Suggestions for Buyer
        _buildQuickReplies(thread),

        // Chat Input Bar
        _buildInputBar(context, thread),
      ],
    );
  }

  Widget _buildStickyDealCard(BuildContext context, ChatThread thread) {
    final total = thread.requestedQuantity * thread.targetPricePerUnit;
    final isAccepted = thread.status == 'accepted';
    final hasCounter = thread.status == 'countered';

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
                        Text(thread.artisanName, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 13.5)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(6)),
                          child: const Text('GI Certified Weaver', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                        ),
                      ],
                    ),
                    Text(thread.productTitle, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
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
          if (hasCounter) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer_rounded, color: Color(0xFF92400E), size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Artisan Counter: ${thread.artisanCounterPrice ?? ''}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                  ),
                  InkWell(
                    onTap: () => _handleAcceptCounter(thread),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(6)),
                      child: const Text('Accept Counter', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (isAccepted) ...[
            Container(
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
                    Icon(Icons.check_circle_rounded, size: 14, color: AppColors.tealDark),
                    SizedBox(width: 6),
                    Text('Deal Locked • Escrow DBT Advance Released to Artisan', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, NegotiationChatMessage msg, ChatThread thread) {
    final isMe = msg.senderRole == 'buyer';
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
                  const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.royalIndigo),
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
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.royalIndigo : AppColors.surface,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg.senderName, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
                  if (msg.isAiAssisted) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.auto_awesome, size: 11, color: AppColors.saffron),
                  ],
                ],
              ),
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
      '📹 Can you share live loom video?',
      '🧵 Can you deliver in 25 days?',
      '📦 Please send 2 fabric swatches',
      '🤝 Agreed! Ready to pay advance',
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
                  hintText: 'Type message to artisan...'.tr,
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

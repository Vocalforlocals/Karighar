import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/negotiation_ai_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/vk_app_bar.dart';

class ChatMessage {
  final String sender;
  final String message;
  final String time;
  final bool isMe;
  final bool isAiAssisted;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.time,
    required this.isMe,
    this.isAiAssisted = false,
  });
}

class ChatNegotiationScreen extends StatefulWidget {
  const ChatNegotiationScreen({super.key});

  @override
  State<ChatNegotiationScreen> createState() => _ChatNegotiationScreenState();
}

class _ChatNegotiationScreenState extends State<ChatNegotiationScreen> {
  final TextEditingController _msgController = TextEditingController();
  bool _isVartaAiActive = true;
  NegotiationEvaluation? _currentEvaluation;

  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'Master Ramdev (Artisan)',
      message: 'Namaste! I received your inquiry for the 25 Varanasi Raw Silk Sarees with antique silver zari borders.',
      time: '11:30 AM',
      isMe: false,
    ),
    ChatMessage(
      sender: 'You',
      message: 'Namaste Ramdev ji. Can we do ₹7,400 per saree if we confirm 30 units and standard GI tag authenticity certificate?',
      time: '11:32 AM',
      isMe: true,
    ),
    ChatMessage(
      sender: 'Master Ramdev (Artisan)',
      message: 'Yes, if order is 30 units, I can prepare raw mulberry katan yarn right away. We will include Government GI verification seals with each box.',
      time: '11:34 AM',
      isMe: false,
    ),
  ];

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        sender: 'You',
        message: text,
        time: 'Just now',
        isMe: true,
      ));
      _msgController.clear();
    });
  }

  void _simulateLowballAndDefend() {
    setState(() {
      _messages.add(ChatMessage(
        sender: 'Corporate Buyer (FabIndia)',
        message: 'We can only offer ₹5,200 per unit for 25 silk sarees. Take it or we source elsewhere.',
        time: 'Just now',
        isMe: false,
      ));

      _currentEvaluation = NegotiationAiService.evaluateOffer(
        offeredPrice: 5200.0,
        catalogPrice: 8500.0,
        requestedQuantity: 25,
        estimatedLoomHours: 32,
      );
    });
  }

  void _sendAiCounterOffer() {
    if (_currentEvaluation == null) return;
    setState(() {
      _messages.add(ChatMessage(
        sender: 'Varta-AI (Artisan Legal Defense)',
        message: _currentEvaluation!.suggestedReplyEnglish,
        time: 'Just now',
        isMe: true,
        isAiAssisted: true,
      ));
      _currentEvaluation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VKAppBar(
        title: 'B2B Negotiation Chat',
        showBackButton: true,
        currentRole: 'buyer',
      ),
      body: Column(
        children: [
          // Varta-AI Wage Defense Sentry Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0F172A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 16, color: AppColors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Varta-AI Wage Sentry: MoSJE Floor Protection Active',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Switch(
                  value: _isVartaAiActive,
                  activeThumbColor: AppColors.teal,
                  onChanged: (val) => setState(() => _isVartaAiActive = val),
                ),
              ],
            ),
          ),

          // Message history list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isAiAssisted
                          ? const Color(0xFF1E293B)
                          : (msg.isMe ? AppColors.teal : AppColors.surface),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: msg.isMe ? const Radius.circular(2) : const Radius.circular(16),
                        bottomLeft: !msg.isMe ? const Radius.circular(2) : const Radius.circular(16),
                      ),
                      border: Border.all(
                        color: msg.isAiAssisted ? AppColors.saffron : (msg.isMe ? Colors.transparent : AppColors.cardBorder),
                        width: msg.isAiAssisted ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.isAiAssisted) ...[
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 12, color: AppColors.saffron),
                              SizedBox(width: 4),
                              Text('VARTA-AI COUNTER-OFFER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.saffron)),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ] else if (!msg.isMe) ...[
                          Text(
                            msg.sender,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.saffronDark),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          msg.message,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: msg.isAiAssisted ? Colors.white : (msg.isMe ? Colors.white : AppColors.textPrimary),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg.time,
                            style: TextStyle(
                              fontSize: 9,
                              color: msg.isAiAssisted ? Colors.white60 : (msg.isMe ? Colors.white70 : AppColors.textLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Varta-AI Warning & Quick Action Alert if evaluation active
          if (_currentEvaluation != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
                      SizedBox(width: 8),
                      Text('LOWBALL DETECTED BY VARTA-AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_currentEvaluation!.reasoning, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.3)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recommended Counter: ₹${_currentEvaluation!.suggestedCounterPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, visualDensity: VisualDensity.compact),
                        icon: const Icon(Icons.send_rounded, size: 14),
                        label: const Text('Send Counter', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        onPressed: _sendAiCounterOffer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Simulation Button Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Simulation Sandbox:', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                TextButton.icon(
                  icon: const Icon(Icons.psychology_rounded, size: 16, color: AppColors.saffron),
                  label: const Text('Test Lowball Defense', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.saffronDark)),
                  onPressed: _simulateLowballAndDefend,
                ),
              ],
            ),
          ),

          // Chat Input Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type offer or custom requirements...',
                        filled: true,
                        fillColor: AppColors.background,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.cardBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.cardBorder)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }
}

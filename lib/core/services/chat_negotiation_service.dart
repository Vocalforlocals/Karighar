import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import 'api_client.dart';

class NegotiationChatMessage {
  final String id;
  final String senderRole; // 'artisan', 'buyer', 'system'
  final String senderName;
  final String text;
  final DateTime timestamp;
  final String messageType; // 'text', 'quote_card', 'counter_card', 'acceptance_card', 'loom_update'
  final Map<String, dynamic>? cardData;
  final bool isAiAssisted;

  NegotiationChatMessage({
    required this.id,
    required this.senderRole,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.messageType = 'text',
    this.cardData,
    this.isAiAssisted = false,
  });
}

class ChatThread {
  final String id;
  final String quoteId;
  final String buyerName;
  final String buyerOrg;
  final String artisanName;
  final String artisanCraft;
  final String productTitle;
  final int requestedQuantity;
  final double targetPricePerUnit;
  final String? artisanCounterPrice;
  final String status; // 'pending', 'countered', 'accepted'
  final int unreadCountArtisan;
  final int unreadCountBuyer;
  final List<NegotiationChatMessage> messages;
  final DateTime lastUpdated;

  ChatThread({
    required this.id,
    required this.quoteId,
    required this.buyerName,
    required this.buyerOrg,
    required this.artisanName,
    required this.artisanCraft,
    required this.productTitle,
    required this.requestedQuantity,
    required this.targetPricePerUnit,
    this.artisanCounterPrice,
    required this.status,
    this.unreadCountArtisan = 0,
    this.unreadCountBuyer = 0,
    required this.messages,
    required this.lastUpdated,
  });

  String get lastMessage => messages.isNotEmpty ? messages.last.text : 'New inquiry started';

  ChatThread copyWith({
    String? status,
    String? artisanCounterPrice,
    int? unreadCountArtisan,
    int? unreadCountBuyer,
    List<NegotiationChatMessage>? messages,
    DateTime? lastUpdated,
  }) {
    return ChatThread(
      id: id,
      quoteId: quoteId,
      buyerName: buyerName,
      buyerOrg: buyerOrg,
      artisanName: artisanName,
      artisanCraft: artisanCraft,
      productTitle: productTitle,
      requestedQuantity: requestedQuantity,
      targetPricePerUnit: targetPricePerUnit,
      artisanCounterPrice: artisanCounterPrice ?? this.artisanCounterPrice,
      status: status ?? this.status,
      unreadCountArtisan: unreadCountArtisan ?? this.unreadCountArtisan,
      unreadCountBuyer: unreadCountBuyer ?? this.unreadCountBuyer,
      messages: messages ?? this.messages,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class ChatNegotiationService extends ChangeNotifier {
  static final ChatNegotiationService instance = ChatNegotiationService._internal();

  ChatNegotiationService._internal() {
    _initInitialThreads();
  }

  final List<ChatThread> _threads = [];
  List<ChatThread> get threads => List.unmodifiable(_threads);

  ChatThread? getThread(String id) {
    try {
      return _threads.firstWhere((t) => t.id == id);
    } catch (_) {
      return _threads.isNotEmpty ? _threads.first : null;
    }
  }

  void _initInitialThreads() {
    _threads.addAll([
      ChatThread(
        id: 'thread_fabindia',
        quoteId: 'quote_301',
        buyerName: 'Sanjay Chawla',
        buyerOrg: 'FabIndia Heritage Boutiques',
        artisanName: 'Master Ramdev',
        artisanCraft: 'Banarasi Handloom Silk Weaver (Varanasi)',
        productTitle: 'Varanasi Raw Mulberry Silk Handloom Saree',
        requestedQuantity: 25,
        targetPricePerUnit: 7200.00,
        artisanCounterPrice: '₹7,600 / unit (Includes certified wooden loom box)',
        status: 'countered',
        unreadCountArtisan: 1,
        unreadCountBuyer: 0,
        lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
        messages: [
          NegotiationChatMessage(
            id: 'm1',
            senderRole: 'buyer',
            senderName: 'Sanjay Chawla (FabIndia)',
            text: 'Namaste Ramdev ji! We are procuring 25 pure raw mulberry silk sarees for our upcoming Diwali flagship launch across Delhi and Mumbai.',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          NegotiationChatMessage(
            id: 'm2',
            senderRole: 'system',
            senderName: 'Karighar B2B Desk',
            text: 'Official Bulk RFP Submitted: 25 Units @ ₹7,200/unit (Total: ₹1,80,000). Target delivery: 35 days.',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            messageType: 'quote_card',
            cardData: {
              'quantity': 25,
              'targetPrice': 7200.0,
              'total': 180000.0,
              'status': 'pending',
            },
          ),
          NegotiationChatMessage(
            id: 'm3',
            senderRole: 'artisan',
            senderName: 'Master Ramdev',
            text: 'Pranam Sanjay ji. Each saree requires 12 days on handloom with 32 hours of intricate zari border work. Under MoSJE Fair Wage norms, our loom cluster counter is ₹7,600 with guaranteed GI certification & customized tamper-evident packaging.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isAiAssisted: true,
            messageType: 'counter_card',
            cardData: {
              'counterPrice': 7600.0,
              'total': 190000.0,
              'reason': 'MoSJE Fair Wage Protected Floor + Handloom GI Tag',
            },
          ),
          NegotiationChatMessage(
            id: 'm4',
            senderRole: 'buyer',
            senderName: 'Sanjay Chawla (FabIndia)',
            text: 'Understood! The GI certification and loom box add tremendous boutique value. If you can include 3 spare sample swatches for our retail buyers, we will accept ₹7,600 immediately.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
        ],
      ),
      ChatThread(
        id: 'thread_oberoi',
        quoteId: 'quote_298',
        buyerName: 'Kavita Menon',
        buyerOrg: 'The Oberoi Hotels & Resorts',
        artisanName: 'Master Ramdev',
        artisanCraft: 'Jaipur Blue Pottery Master',
        productTitle: 'Jaipur Blue Pottery Royal Cobalt Floral Vase',
        requestedQuantity: 50,
        targetPricePerUnit: 1950.00,
        status: 'accepted',
        unreadCountArtisan: 0,
        unreadCountBuyer: 0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        messages: [
          NegotiationChatMessage(
            id: 'ob_1',
            senderRole: 'buyer',
            senderName: 'Kavita Menon (Oberoi)',
            text: 'Hello, we require 50 units of royal cobalt vases for our heritage luxury suites in Udaipur.',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
          ),
          NegotiationChatMessage(
            id: 'ob_2',
            senderRole: 'system',
            senderName: 'Karighar B2B Desk',
            text: 'Offer Accepted: 50 Units @ ₹1,950/unit (Total: ₹97,500). Advance of ₹48,750 deposited in Escrow DBT.',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            messageType: 'acceptance_card',
            cardData: {
              'quantity': 50,
              'price': 1950.0,
              'total': 97500.0,
              'escrowAdvance': 48750.0,
              'status': 'accepted',
            },
          ),
          NegotiationChatMessage(
            id: 'ob_3',
            senderRole: 'artisan',
            senderName: 'Master Ramdev',
            text: 'Thank you Kavita ji! Kiln firing for the first 25 pieces is completed. Fragile shock-proof crate packing is underway.',
            timestamp: DateTime.now().subtract(const Duration(hours: 18)),
          ),
        ],
      ),
      ChatThread(
        id: 'thread_ananya',
        quoteId: 'quote_custom_01',
        buyerName: 'Ananya Sharma',
        buyerOrg: 'Boutique Collector (Mumbai)',
        artisanName: 'Master Ramdev',
        artisanCraft: 'Banarasi Master Weaver',
        productTitle: 'Custom Bridal Katan Saree with Pure Gold Zari',
        requestedQuantity: 2,
        targetPricePerUnit: 14500.00,
        status: 'pending',
        unreadCountArtisan: 1,
        unreadCountBuyer: 0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        messages: [
          NegotiationChatMessage(
            id: 'an_1',
            senderRole: 'buyer',
            senderName: 'Ananya Sharma',
            text: 'Pranam! I saw your loom craft on the app story reel. Can you weave 2 custom bridal sarees with peacock pallu motifs for my sister’s wedding in November?',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
    ]);
  }

  void sendMessage({
    required String threadId,
    required String senderRole,
    required String senderName,
    required String text,
    bool isAiAssisted = false,
    String messageType = 'text',
    Map<String, dynamic>? cardData,
  }) {
    final idx = _threads.indexWhere((t) => t.id == threadId);
    if (idx == -1) return;

    final oldThread = _threads[idx];
    final newMsg = NegotiationChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderRole: senderRole,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isAiAssisted: isAiAssisted,
      messageType: messageType,
      cardData: cardData,
    );

    final updatedMessages = List<NegotiationChatMessage>.from(oldThread.messages)..add(newMsg);

    _threads[idx] = oldThread.copyWith(
      messages: updatedMessages,
      lastUpdated: DateTime.now(),
      unreadCountArtisan: senderRole == 'buyer' ? oldThread.unreadCountArtisan + 1 : oldThread.unreadCountArtisan,
      unreadCountBuyer: senderRole == 'artisan' ? oldThread.unreadCountBuyer + 1 : oldThread.unreadCountBuyer,
    );

    notifyListeners();

    // Asynchronous backend persistence
    ApiClient.sendChatMessage(
      threadId,
      text: text,
      senderRole: senderRole,
      senderName: senderName,
      messageType: messageType,
      cardData: cardData,
      isAiAssisted: isAiAssisted,
    ).catchError((e) {
      debugPrint('ChatNegotiationService.sendMessage sync notice: $e');
      return null;
    });
  }

  void sendCounterOffer({
    required String threadId,
    required String senderRole,
    required String senderName,
    required double counterPrice,
    required String explanation,
    bool isAi = false,
  }) {
    final idx = _threads.indexWhere((t) => t.id == threadId);
    if (idx == -1) return;

    final oldThread = _threads[idx];
    final total = counterPrice * oldThread.requestedQuantity;
    final counterText = 'Counter Offer: ₹${counterPrice.toStringAsFixed(0)} / unit (Total: ₹${total.toStringAsFixed(0)}). $explanation';

    final newMsg = NegotiationChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderRole: senderRole,
      senderName: senderName,
      text: counterText,
      timestamp: DateTime.now(),
      isAiAssisted: isAi,
      messageType: 'counter_card',
      cardData: {
        'counterPrice': counterPrice,
        'quantity': oldThread.requestedQuantity,
        'total': total,
        'notes': explanation,
      },
    );

    final updatedMessages = List<NegotiationChatMessage>.from(oldThread.messages)..add(newMsg);

    _threads[idx] = oldThread.copyWith(
      status: 'countered',
      artisanCounterPrice: '₹${counterPrice.toStringAsFixed(0)} / unit ($explanation)',
      messages: updatedMessages,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();

    // Asynchronous backend persistence
    ApiClient.submitCounterOffer(
      threadId,
      counterPrice: counterPrice,
      note: explanation,
    ).catchError((e) {
      debugPrint('ChatNegotiationService.sendCounterOffer sync notice: $e');
      return null;
    });
  }

  void acceptOffer({
    required String threadId,
    required String senderRole,
    required String senderName,
  }) {
    final idx = _threads.indexWhere((t) => t.id == threadId);
    if (idx == -1) return;

    final oldThread = _threads[idx];
    final finalPrice = oldThread.artisanCounterPrice != null
        ? (double.tryParse(oldThread.artisanCounterPrice!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? oldThread.targetPricePerUnit)
        : oldThread.targetPricePerUnit;
    final total = finalPrice * oldThread.requestedQuantity;

    final acceptanceText = '🎉 Offer Officially Accepted! Order locked at ₹${finalPrice.toStringAsFixed(0)}/unit (Total: ₹${total.toStringAsFixed(0)}). Advance payment released into Escrow.';

    final newMsg = NegotiationChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderRole: 'system',
      senderName: 'Karighar Deal Lock',
      text: acceptanceText,
      timestamp: DateTime.now(),
      messageType: 'acceptance_card',
      cardData: {
        'price': finalPrice,
        'quantity': oldThread.requestedQuantity,
        'total': total,
        'status': 'accepted',
      },
    );

    final updatedMessages = List<NegotiationChatMessage>.from(oldThread.messages)..add(newMsg);

    _threads[idx] = oldThread.copyWith(
      status: 'accepted',
      messages: updatedMessages,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();

    // Asynchronous backend persistence
    ApiClient.acceptNegotiationDeal(threadId).catchError((e) {
      debugPrint('ChatNegotiationService.acceptOffer sync notice: $e');
      return null;
    });
  }

  void addThreadFromBulkQuote(BulkQuote quote) {
    if (_threads.any((t) => t.quoteId == quote.id)) return;

    final thread = ChatThread(
      id: 'thread_${quote.id}',
      quoteId: quote.id,
      buyerName: quote.buyerName.isNotEmpty ? quote.buyerName : 'Verified Buyer',
      buyerOrg: quote.buyerOrg.isNotEmpty ? quote.buyerOrg : 'Retail Partner',
      artisanName: 'Master Artisan',
      artisanCraft: 'Certified Heritage Artisan',
      productTitle: quote.productTitle,
      requestedQuantity: quote.requestedQuantity,
      targetPricePerUnit: quote.targetPricePerUnit,
      status: quote.status,
      lastUpdated: quote.requestedAt,
      messages: [
        NegotiationChatMessage(
          id: 'q_init',
          senderRole: 'buyer',
          senderName: quote.buyerName.isNotEmpty ? quote.buyerName : 'Buyer',
          text: quote.notes.isNotEmpty ? quote.notes : 'Inquiry initiated for ${quote.requestedQuantity} units of ${quote.productTitle}.',
          timestamp: quote.requestedAt,
        ),
        NegotiationChatMessage(
          id: 'q_card',
          senderRole: 'system',
          senderName: 'Karighar B2B Desk',
          text: 'Official Bulk Quote: ${quote.requestedQuantity} Units @ ₹${quote.targetPricePerUnit.toStringAsFixed(0)}/unit.',
          timestamp: quote.requestedAt,
          messageType: 'quote_card',
          cardData: {
            'quantity': quote.requestedQuantity,
            'targetPrice': quote.targetPricePerUnit,
            'total': quote.requestedQuantity * quote.targetPricePerUnit,
            'status': quote.status,
          },
        ),
      ],
    );

    _threads.insert(0, thread);
    notifyListeners();

    // Asynchronous backend persistence
    ApiClient.createChatThread({
      'id': thread.id,
      'quoteId': quote.id,
      'buyerName': quote.buyerName,
      'buyerOrg': quote.buyerOrg,
      'productTitle': quote.productTitle,
      'requestedQuantity': quote.requestedQuantity,
      'targetPricePerUnit': quote.targetPricePerUnit,
      'initialMessage': quote.notes,
    }).catchError((e) {
      debugPrint('ChatNegotiationService.createChatThread sync notice: $e');
      return null;
    });
  }

  void markAsRead(String threadId, String role) {
    final idx = _threads.indexWhere((t) => t.id == threadId);
    if (idx == -1) return;

    final oldThread = _threads[idx];
    if (role == 'artisan' && oldThread.unreadCountArtisan > 0) {
      _threads[idx] = oldThread.copyWith(unreadCountArtisan: 0);
      notifyListeners();
    } else if (role == 'buyer' && oldThread.unreadCountBuyer > 0) {
      _threads[idx] = oldThread.copyWith(unreadCountBuyer: 0);
      notifyListeners();
    }
  }
}

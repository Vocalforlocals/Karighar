import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/quote.dart';

class SyncClientService {
  static final SyncClientService _instance = SyncClientService._internal();
  factory SyncClientService() => _instance;
  SyncClientService._internal() {
    _startSseListener();
  }

  final _eventStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get eventStream => _eventStreamController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  http.Client? _httpClient;

  void _startSseListener() {
    try {
      _connectSse();
    } catch (e) {
      debugPrint('[SyncClient] SSE auto-connect deferred: $e');
    }
  }

  Future<void> _connectSse() async {
    try {
      _httpClient = http.Client();
      final uri = Uri.parse('${ApiClient.baseUrl}/api/sync/events');
      final request = http.Request('GET', uri)
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final response = await _httpClient!.send(request).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        _isConnected = true;
        debugPrint('[SyncClient] Connected to live SSE event stream at $uri');

        response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
          (line) {
            if (line.startsWith('data: ')) {
              final jsonStr = line.substring(6).trim();
              try {
                final payload = jsonDecode(jsonStr);
                if (payload is Map<String, dynamic>) {
                  _eventStreamController.add(payload);
                  debugPrint('[SyncClient] Live SSE event received: ${payload['type']}');
                }
              } catch (_) {}
            }
          },
          onError: (err) {
            _isConnected = false;
          },
          onDone: () {
            _isConnected = false;
          },
        );
      }
    } catch (e) {
      _isConnected = false;
    }
  }

  void broadcastEvent(String type, Map<String, dynamic> data) {
    final payload = {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    _eventStreamController.add(payload);
    debugPrint('[SyncClient] Local broadcast emitted: $type');
  }

  void broadcastNewProduct(Product product) {
    broadcastEvent('PRODUCT_PUBLISHED', {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'artisanName': product.artisanName,
      'clusterLocation': product.clusterLocation,
      'craftForm': product.craftForm,
      'category': product.category,
      'image': product.images.first,
    });
  }

  void broadcastNewOrder(OrderItem order) {
    broadcastEvent('ORDER_PLACED', {
      'id': order.id,
      'productTitle': order.productTitle,
      'totalPrice': order.totalPrice,
      'buyerName': order.buyerName,
      'status': order.status,
    });
  }

  void broadcastQuoteStatus(BulkQuote quote) {
    broadcastEvent('QUOTE_UPDATED', {
      'id': quote.id,
      'productTitle': quote.productTitle,
      'buyerOrg': quote.buyerOrg,
      'status': quote.status,
      'targetPricePerUnit': quote.targetPricePerUnit,
    });
  }

  void dispose() {
    _httpClient?.close();
    _eventStreamController.close();
  }
}

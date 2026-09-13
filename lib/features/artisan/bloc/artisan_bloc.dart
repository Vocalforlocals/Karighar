import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/mock_repository.dart';
import '../../../core/models/product.dart';
import '../../../core/models/order.dart';
import '../../../core/models/quote.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/sync_client_service.dart';

// EVENTS
abstract class ArtisanEvent extends Equatable {
  const ArtisanEvent();
  @override
  List<Object?> get props => [];
}

class LoadArtisanDataEvent extends ArtisanEvent {}

class CreateProductEvent extends ArtisanEvent {
  final Product product;
  const CreateProductEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class UpdateOrderStatusEvent extends ArtisanEvent {
  final String orderId;
  final String newStatus;
  const UpdateOrderStatusEvent(this.orderId, this.newStatus);
  @override
  List<Object?> get props => [orderId, newStatus];
}

class RespondToQuoteEvent extends ArtisanEvent {
  final String quoteId;
  final String responseStatus;
  final String? counterPrice;
  const RespondToQuoteEvent({required this.quoteId, required this.responseStatus, this.counterPrice});
  @override
  List<Object?> get props => [quoteId, responseStatus, counterPrice];
}

// STATES
enum ArtisanStatus { initial, loading, loaded, error }

class ArtisanState extends Equatable {
  final ArtisanStatus status;
  final List<Product> products;
  final List<OrderItem> orders;
  final List<BulkQuote> quotes;
  final double totalRevenue;
  final int activeLoomCount;
  final String? errorMessage;

  const ArtisanState({
    this.status = ArtisanStatus.initial,
    this.products = const [],
    this.orders = const [],
    this.quotes = const [],
    this.totalRevenue = 48500.00,
    this.activeLoomCount = 3,
    this.errorMessage,
  });

  ArtisanState copyWith({
    ArtisanStatus? status,
    List<Product>? products,
    List<OrderItem>? orders,
    List<BulkQuote>? quotes,
    double? totalRevenue,
    int? activeLoomCount,
    String? errorMessage,
  }) {
    return ArtisanState(
      status: status ?? this.status,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      quotes: quotes ?? this.quotes,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      activeLoomCount: activeLoomCount ?? this.activeLoomCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, orders, quotes, totalRevenue, activeLoomCount, errorMessage];
}

// BLOC
class ArtisanBloc extends Bloc<ArtisanEvent, ArtisanState> {
  StreamSubscription? _syncSub;

  ArtisanBloc() : super(const ArtisanState()) {
    on<LoadArtisanDataEvent>(_onLoadArtisanData);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<RespondToQuoteEvent>(_onRespondToQuote);

    _syncSub = SyncClientService().eventStream.listen((event) {
      if (event['type'] == 'PRODUCT_CREATED' && event['payload'] != null) {
        final p = event['payload'];
        try {
          final prod = Product(
            id: p['id'] ?? 'prod_live',
            artisanId: p['artisanId'] ?? 'art_ramdev_01',
            artisanName: p['artisanName'] ?? 'Master Ramdev',
            title: p['title'] ?? 'Live Craft',
            category: p['category'] ?? 'Textiles & Weaves',
            craftForm: p['craftForm'] ?? 'Handloom Craft',
            description: p['description'] ?? '',
            images: (p['images'] as List?)?.map((e) => e.toString()).toList() ?? ['https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800'],
            rawImage: p['rawImage'] ?? '',
            price: (p['price'] as num?)?.toDouble() ?? 5000.0,
            estimatedHours: (p['estimatedHours'] as num?)?.toInt() ?? 48,
            isGICertified: true,
            giTagNumber: p['giTagNumber'] ?? 'GI-IN-2026',
            clusterLocation: p['clusterLocation'] ?? 'Varanasi',
            stockQuantity: (p['stockQuantity'] as num?)?.toInt() ?? 1,
            status: 'active',
            tags: (p['tags'] as List?)?.map((e) => e.toString()).toList() ?? ['Handloom'],
            materialsUsed: (p['materialsUsed'] as List?)?.map((e) => e.toString()).toList() ?? [],
            aiEnhancementsApplied: (p['aiEnhancementsApplied'] as List?)?.map((e) => e.toString()).toList() ?? [],
            createdAt: DateTime.now(),
          );
          add(CreateProductEvent(prod));
        } catch (_) {}
      }
    });
  }

  Future<void> _onLoadArtisanData(LoadArtisanDataEvent event, Emitter<ArtisanState> emit) async {
    emit(state.copyWith(status: ArtisanStatus.loading));
    try {
      final products = await ApiClient.getProducts();
      final orders = await ApiClient.getOrders();

      List<BulkQuote> quotes;
      try {
        final quotesJson = await ApiClient.getArtisanQuotes();
        if (quotesJson.isNotEmpty) {
          quotes = quotesJson.map((q) => BulkQuote.fromJson(q)).toList();
        } else {
          quotes = MockRepository.getInitialQuotes();
        }
      } catch (_) {
        quotes = MockRepository.getInitialQuotes();
      }

      double totalRevenue = 48500.00;
      int activeLoomCount = 3;
      try {
        final stats = await ApiClient.getArtisanStats();
        if (stats.containsKey('totalGmv')) {
          totalRevenue = (stats['totalGmv'] as num).toDouble();
        }
        if (stats.containsKey('activeLoomCount')) {
          activeLoomCount = (stats['activeLoomCount'] as num).toInt();
        }
      } catch (_) {}

      emit(state.copyWith(
        status: ArtisanStatus.loaded,
        products: products,
        orders: orders,
        quotes: quotes,
        totalRevenue: totalRevenue,
        activeLoomCount: activeLoomCount,
      ));
    } catch (e) {
      final products = MockRepository.getInitialProducts();
      final orders = MockRepository.getInitialOrders();
      final quotes = MockRepository.getInitialQuotes();
      emit(state.copyWith(
        status: ArtisanStatus.loaded,
        products: products,
        orders: orders,
        quotes: quotes,
      ));
    }
  }

  void _onCreateProduct(CreateProductEvent event, Emitter<ArtisanState> emit) {
    if (state.products.any((p) => p.id == event.product.id)) return;
    final updatedList = [event.product, ...state.products];
    emit(state.copyWith(products: updatedList));
  }

  void _onUpdateOrderStatus(UpdateOrderStatusEvent event, Emitter<ArtisanState> emit) {
    final updatedOrders = state.orders.map((o) {
      if (o.id == event.orderId) {
        return o.copyWith(status: event.newStatus);
      }
      return o;
    }).toList();
    emit(state.copyWith(orders: updatedOrders));
  }

  void _onRespondToQuote(RespondToQuoteEvent event, Emitter<ArtisanState> emit) {
    final updatedQuotes = state.quotes.map((q) {
      if (q.id == event.quoteId) {
        return q.copyWith(
          status: event.responseStatus,
          artisanCounterPrice: event.counterPrice ?? q.artisanCounterPrice,
        );
      }
      return q;
    }).toList();
    emit(state.copyWith(quotes: updatedQuotes));
  }

  @override
  Future<void> close() {
    _syncSub?.cancel();
    return super.close();
  }
}


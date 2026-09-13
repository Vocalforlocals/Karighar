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
abstract class BuyerEvent extends Equatable {
  const BuyerEvent();
  @override
  List<Object?> get props => [];
}

class LoadBuyerMarketplaceEvent extends BuyerEvent {}

class SearchQueryChangedEvent extends BuyerEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class CategorySelectedEvent extends BuyerEvent {
  final String category;
  const CategorySelectedEvent(this.category);
  @override
  List<Object?> get props => [category];
}

class AddToCartEvent extends BuyerEvent {
  final Product product;
  const AddToCartEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class RemoveFromCartEvent extends BuyerEvent {
  final String productId;
  const RemoveFromCartEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class SubmitBuyerQuoteEvent extends BuyerEvent {
  final BulkQuote quote;
  const SubmitBuyerQuoteEvent(this.quote);
  @override
  List<Object?> get props => [quote];
}

class AddMarketplaceProductEvent extends BuyerEvent {
  final Product product;
  const AddMarketplaceProductEvent(this.product);
  @override
  List<Object?> get props => [product];
}

// STATES
enum BuyerStatus { initial, loading, loaded, error }

class BuyerState extends Equatable {
  final BuyerStatus status;
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String selectedCategory;
  final String searchQuery;
  final List<Product> cartItems;
  final List<BulkQuote> submittedQuotes;
  final List<OrderItem> buyerOrders;
  final String? errorMessage;

  const BuyerState({
    this.status = BuyerStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.cartItems = const [],
    this.submittedQuotes = const [],
    this.buyerOrders = const [],
    this.errorMessage,
  });

  double get cartTotal => cartItems.fold(0.0, (sum, item) => sum + item.price);

  BuyerState copyWith({
    BuyerStatus? status,
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    String? selectedCategory,
    String? searchQuery,
    List<Product>? cartItems,
    List<BulkQuote>? submittedQuotes,
    List<OrderItem>? buyerOrders,
    String? errorMessage,
  }) {
    return BuyerState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      cartItems: cartItems ?? this.cartItems,
      submittedQuotes: submittedQuotes ?? this.submittedQuotes,
      buyerOrders: buyerOrders ?? this.buyerOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        selectedCategory,
        searchQuery,
        cartItems,
        submittedQuotes,
        buyerOrders,
        errorMessage,
      ];
}

// BLOC
class BuyerBloc extends Bloc<BuyerEvent, BuyerState> {
  StreamSubscription? _syncSub;

  BuyerBloc() : super(const BuyerState()) {
    on<LoadBuyerMarketplaceEvent>(_onLoadMarketplace);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<CategorySelectedEvent>(_onCategorySelected);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<SubmitBuyerQuoteEvent>(_onSubmitBuyerQuote);
    on<AddMarketplaceProductEvent>(_onAddMarketplaceProduct);

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
          add(AddMarketplaceProductEvent(prod));
        } catch (_) {}
      }
    });
  }

  Future<void> _onLoadMarketplace(LoadBuyerMarketplaceEvent event, Emitter<BuyerState> emit) async {
    emit(state.copyWith(status: BuyerStatus.loading));
    try {
      final products = await ApiClient.getProducts();
      final orders = await ApiClient.getOrders();
      final quotes = MockRepository.getInitialQuotes();
      emit(state.copyWith(
        status: BuyerStatus.loaded,
        allProducts: products,
        filteredProducts: products,
        buyerOrders: orders,
        submittedQuotes: quotes,
      ));
    } catch (e) {
      final fallbackProducts = MockRepository.getInitialProducts();
      final fallbackOrders = MockRepository.getInitialOrders();
      final fallbackQuotes = MockRepository.getInitialQuotes();
      emit(state.copyWith(
        status: BuyerStatus.loaded,
        allProducts: fallbackProducts,
        filteredProducts: fallbackProducts,
        buyerOrders: fallbackOrders,
        submittedQuotes: fallbackQuotes,
      ));
    }
  }

  void _onSearchQueryChanged(SearchQueryChangedEvent event, Emitter<BuyerState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.allProducts.where((p) {
      final matchesQuery = p.title.toLowerCase().contains(query) ||
          p.craftForm.toLowerCase().contains(query) ||
          p.clusterLocation.toLowerCase().contains(query);
      final matchesCategory = state.selectedCategory == 'All' || p.category == state.selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    emit(state.copyWith(searchQuery: event.query, filteredProducts: filtered));
  }

  void _onCategorySelected(CategorySelectedEvent event, Emitter<BuyerState> emit) {
    final category = event.category;
    final filtered = state.allProducts.where((p) {
      final matchesCategory = category == 'All' || p.category == category;
      final matchesQuery = state.searchQuery.isEmpty ||
          p.title.toLowerCase().contains(state.searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    emit(state.copyWith(selectedCategory: category, filteredProducts: filtered));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<BuyerState> emit) {
    final updatedCart = [...state.cartItems, event.product];
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<BuyerState> emit) {
    final updatedCart = state.cartItems.where((p) => p.id != event.productId).toList();
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onSubmitBuyerQuote(SubmitBuyerQuoteEvent event, Emitter<BuyerState> emit) {
    final updatedQuotes = [event.quote, ...state.submittedQuotes];
    emit(state.copyWith(submittedQuotes: updatedQuotes));
  }

  void _onAddMarketplaceProduct(AddMarketplaceProductEvent event, Emitter<BuyerState> emit) {
    if (state.allProducts.any((p) => p.id == event.product.id)) return;
    final updatedAll = [event.product, ...state.allProducts];
    final updatedFiltered = [event.product, ...state.filteredProducts];
    emit(state.copyWith(allProducts: updatedAll, filteredProducts: updatedFiltered));
  }

  @override
  Future<void> close() {
    _syncSub?.cancel();
    return super.close();
  }
}


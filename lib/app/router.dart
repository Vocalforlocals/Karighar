import 'package:go_router/go_router.dart';
import '../core/services/api_client.dart';
import '../features/artisan/presentation/artisan_shell_screen.dart';
import '../features/artisan/presentation/artisan_dashboard_screen.dart';
import '../features/artisan/presentation/studio_wizard_screen.dart';
import '../features/artisan/presentation/artisan_orders_screen.dart';
import '../features/artisan/presentation/artisan_quotes_screen.dart';
import '../features/artisan/presentation/artisan_earnings_screen.dart';
import '../features/artisan/presentation/cluster_order_pooling_screen.dart';
import '../features/artisan/presentation/karighar_credit_screen.dart';
import '../features/buyer/presentation/buyer_shell_screen.dart';
import '../features/buyer/presentation/buyer_home_screen.dart';
import '../features/buyer/presentation/buyer_explore_screen.dart';
import '../features/buyer/presentation/buyer_stories_screen.dart';
import '../features/buyer/presentation/buyer_profile_screen.dart';
import '../features/buyer/presentation/product_detail_screen.dart';
import '../features/buyer/presentation/cart_screen.dart';
import '../features/buyer/presentation/buyer_quotes_screen.dart';
import '../features/buyer/presentation/craft_passport_screen.dart';
import '../features/buyer/presentation/rfp_tender_board_screen.dart';
import '../features/buyer/presentation/ar_craft_viewer_screen.dart';
import '../features/buyer/presentation/invoice_preview_screen.dart';
import '../features/buyer/presentation/export_customs_screen.dart';
import '../features/buyer/presentation/delivery_verification_screen.dart';
import '../features/buyer/presentation/buyer_payment_screen.dart';
import '../features/buyer/presentation/order_tracking_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/admin/presentation/gis_cluster_map_screen.dart';
import '../features/trust/presentation/blockchain_explorer_screen.dart';
import '../features/error/presentation/not_found_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/buyer',
    redirect: (context, state) {
      final loc = state.matchedLocation;
      if (loc.startsWith('/artisan') || loc.startsWith('/studio') || loc == '/add-product') {
        final user = ApiClient.currentUser;
        final isArtisan = user != null && user.role.toUpperCase() == 'ARTISAN';
        if (!isArtisan) {
          return '/buyer/profile';
        }
      }
      return null;
    },
    errorBuilder: (context, state) => NotFoundScreen(path: state.uri.toString()),
    routes: [
      // DEFAULT ROOT ENTRY -> BUYER HOME SCREEN
      GoRoute(
        path: '/',
        redirect: (context, state) => '/buyer',
      ),
      // AUTH & ONBOARDING DIRECTED TO PROFILE SECTION
      GoRoute(
        path: '/login',
        redirect: (context, state) => '/buyer/profile',
      ),
      GoRoute(
        path: '/register',
        redirect: (context, state) => '/buyer/profile',
      ),
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/buyer/profile',
      ),
      GoRoute(
        path: '/role-selection',
        redirect: (context, state) => '/buyer/profile',
      ),

      // 🎨 TOP-LEVEL AI STUDIO WIZARD ALIASES (ROLE-GUARDED)
      GoRoute(
        path: '/studio',
        redirect: (context, state) {
          final user = ApiClient.currentUser;
          if (user == null || user.role.toUpperCase() != 'ARTISAN') {
            return '/buyer/profile';
          }
          return '/artisan/studio';
        },
      ),
      GoRoute(
        path: '/studio-wizard',
        redirect: (context, state) {
          final user = ApiClient.currentUser;
          if (user == null || user.role.toUpperCase() != 'ARTISAN') {
            return '/buyer/profile';
          }
          return '/artisan/studio';
        },
      ),
      GoRoute(
        path: '/add-product',
        redirect: (context, state) {
          final user = ApiClient.currentUser;
          if (user == null || user.role.toUpperCase() != 'ARTISAN') {
            return '/buyer/profile';
          }
          return '/artisan/add-product';
        },
      ),

      // 🎨 ARTISAN APP WITH PERSISTENT BOTTOM NAVIGATION SHELL (SELLER ONLY)
      ShellRoute(
        builder: (context, state, child) => ArtisanShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/artisan',
            redirect: (context, state) {
              final user = ApiClient.currentUser;
              final isArtisan = user != null && user.role.toUpperCase() == 'ARTISAN';
              if (!isArtisan) {
                // Non-artisan users (Buyers or guests) are restricted from accessing Seller Studio
                return '/buyer/profile';
              }
              return null; // Artisan granted access
            },
            builder: (context, state) => const ArtisanDashboardScreen(),
            routes: [
              GoRoute(
                path: 'add-product',
                builder: (context, state) => const StudioWizardScreen(),
              ),
              GoRoute(
                path: 'studio',
                builder: (context, state) => const StudioWizardScreen(),
              ),
              GoRoute(
                path: 'studio-wizard',
                builder: (context, state) => const StudioWizardScreen(),
              ),
              GoRoute(
                path: 'orders',
                builder: (context, state) => const ArtisanOrdersScreen(),
              ),
              GoRoute(
                path: 'quotes',
                builder: (context, state) => const ArtisanQuotesScreen(),
              ),
              GoRoute(
                path: 'chat',
                builder: (context, state) => const ArtisanQuotesScreen(),
              ),
              GoRoute(
                path: 'earnings',
                builder: (context, state) => const ArtisanEarningsScreen(),
              ),
              GoRoute(
                path: 'cluster-pooling',
                builder: (context, state) => const ClusterOrderPoolingScreen(),
              ),
              GoRoute(
                path: 'credit',
                builder: (context, state) => const KarigharCreditScreen(),
              ),
              GoRoute(
                path: 'karighar-credit',
                builder: (context, state) => const KarigharCreditScreen(),
              ),
              GoRoute(
                path: 'shilp-credit',
                builder: (context, state) => const KarigharCreditScreen(),
              ),
            ],
          ),
        ],
      ),

      // 🛍️ BUYER APP WITH PERSISTENT BOTTOM NAVIGATION SHELL
      ShellRoute(
        builder: (context, state, child) => BuyerShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/buyer',
            builder: (context, state) => const BuyerHomeScreen(),
            routes: [
              GoRoute(
                path: 'product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? 'prod_01';
                  return ProductDetailScreen(productId: id);
                },
              ),
              GoRoute(
                path: 'passport/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? 'prod_01';
                  return CraftPassportScreen(productId: id);
                },
              ),
              GoRoute(
                path: 'tenders',
                builder: (context, state) => const RfpTenderBoardScreen(),
              ),
              GoRoute(
                path: 'ar/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? 'prod_01';
                  return ArCraftViewerScreen(productId: id);
                },
              ),
              GoRoute(
                path: 'explore',
                builder: (context, state) => const BuyerExploreScreen(),
              ),
              GoRoute(
                path: 'stories',
                builder: (context, state) => const BuyerStoriesScreen(),
              ),
              GoRoute(
                path: 'profile',
                builder: (context, state) => const BuyerProfileScreen(),
              ),
              GoRoute(
                path: 'cart',
                builder: (context, state) => const CartScreen(),
              ),
              GoRoute(
                path: 'quotes',
                builder: (context, state) => const BuyerQuotesScreen(),
              ),
              GoRoute(
                path: 'chat',
                builder: (context, state) => const BuyerQuotesScreen(),
              ),
              GoRoute(
                path: 'invoice',
                builder: (context, state) {
                  final orderId = state.uri.queryParameters['orderId'] ?? 'ORD-2026-9041';
                  final title = state.uri.queryParameters['title'] ?? 'Banarasi Katan Silk Saree';
                  final price = double.tryParse(state.uri.queryParameters['price'] ?? '8500') ?? 8500.0;
                  return InvoicePreviewScreen(
                    orderId: orderId,
                    productTitle: title,
                    totalPrice: price,
                  );
                },
              ),
              GoRoute(
                path: 'export-customs',
                builder: (context, state) {
                  final title = state.uri.queryParameters['title'] ?? 'Banarasi Katan Silk Handloom Saree';
                  final price = double.tryParse(state.uri.queryParameters['price'] ?? '8500') ?? 8500.0;
                  return ExportCustomsScreen(productTitle: title, priceInr: price);
                },
              ),
              GoRoute(
                path: 'delivery-verification/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? 'ORD-2026-9041';
                  final amount = double.tryParse(state.uri.queryParameters['amount'] ?? '8500') ?? 8500.0;
                  final title = state.uri.queryParameters['title'] ?? 'Banarasi Katan Silk Handloom Saree';
                  return DeliveryVerificationScreen(orderId: id, amount: amount, productTitle: title);
                },
              ),
              GoRoute(
                path: 'ledger',
                builder: (context, state) {
                  final q = state.uri.queryParameters['q'];
                  return BlockchainExplorerScreen(initialSearch: q);
                },
              ),
              GoRoute(
                path: 'payment',
                builder: (context, state) => const BuyerPaymentScreen(),
              ),
              GoRoute(
                path: 'track/:orderId',
                builder: (context, state) {
                  final orderId = state.pathParameters['orderId'] ?? 'ORD-2026-9041';
                  return OrderTrackingScreen(orderId: orderId);
                },
              ),
            ],
          ),
        ],
      ),

      // 🛡️ ADMIN PANEL
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'gis-map',
            builder: (context, state) => const GisClusterMapScreen(),
          ),
        ],
      ),

      // ⛓️ BLOCKCHAIN EXPLORER & GLOBAL FEATURE ALIASES
      GoRoute(
        path: '/ledger',
        builder: (context, state) {
          final q = state.uri.queryParameters['q'];
          return BlockchainExplorerScreen(initialSearch: q);
        },
      ),
      GoRoute(
        path: '/blockchain',
        builder: (context, state) {
          final q = state.uri.queryParameters['q'];
          return BlockchainExplorerScreen(initialSearch: q);
        },
      ),
      GoRoute(
        path: '/explorer',
        builder: (context, state) {
          final q = state.uri.queryParameters['q'];
          return BlockchainExplorerScreen(initialSearch: q);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/tenders',
        builder: (context, state) => const RfpTenderBoardScreen(),
      ),
      GoRoute(
        path: '/credit',
        builder: (context, state) => const KarigharCreditScreen(),
      ),
      GoRoute(
        path: '/karighar-credit',
        builder: (context, state) => const KarigharCreditScreen(),
      ),
      GoRoute(
        path: '/shilp-credit',
        builder: (context, state) => const KarigharCreditScreen(),
      ),
      GoRoute(
        path: '/pooling',
        builder: (context, state) => const ClusterOrderPoolingScreen(),
      ),
      GoRoute(
        path: '/customs',
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'Banarasi Katan Silk Handloom Saree';
          final price = double.tryParse(state.uri.queryParameters['price'] ?? '8500') ?? 8500.0;
          return ExportCustomsScreen(productTitle: title, priceInr: price);
        },
      ),
      GoRoute(
        path: '/gis',
        builder: (context, state) => const GisClusterMapScreen(),
      ),
      GoRoute(
        path: '/gis-map',
        builder: (context, state) => const GisClusterMapScreen(),
      ),
    ],
  );
}


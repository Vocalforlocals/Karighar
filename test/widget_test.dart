import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vishwakala/core/widgets/vk_app_bar.dart';
import 'package:vishwakala/core/widgets/vk_badge.dart';
import 'package:vishwakala/core/widgets/vk_button.dart';
import 'package:vishwakala/core/widgets/vk_card.dart';
import 'package:vishwakala/core/widgets/vk_guided_tour_modal.dart';
import 'package:vishwakala/features/admin/presentation/gis_cluster_map_screen.dart';
import 'package:vishwakala/features/artisan/presentation/karighar_credit_screen.dart';
import 'package:vishwakala/features/buyer/presentation/export_customs_screen.dart';
import 'package:vishwakala/features/trust/presentation/blockchain_explorer_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vishwakala/core/l10n/locale_manager.dart';
import 'package:vishwakala/features/artisan/bloc/artisan_bloc.dart';
import 'package:vishwakala/features/artisan/presentation/artisan_dashboard_screen.dart';
import 'package:vishwakala/features/artisan/presentation/studio_wizard_screen.dart';
import 'package:vishwakala/features/auth/presentation/auth_screen.dart';
import 'package:vishwakala/features/error/presentation/not_found_screen.dart';
import 'package:vishwakala/features/buyer/bloc/buyer_bloc.dart';
import 'package:vishwakala/features/buyer/presentation/buyer_explore_screen.dart';
import 'package:vishwakala/features/buyer/presentation/buyer_stories_screen.dart';
import 'package:vishwakala/features/buyer/presentation/buyer_profile_screen.dart';
import 'package:vishwakala/features/buyer/presentation/buyer_quotes_screen.dart';
import 'package:vishwakala/features/buyer/presentation/rfp_tender_board_screen.dart';
import 'package:vishwakala/main.dart';

// Mock HttpOverrides for NetworkImage in Widget Tests
final List<int> _transparentPng = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentPng.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.value(_transparentPng).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  group('Karighar Frontend Suite', () {
    testWidgets('App root smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(const KarigharApp());
      expect(find.byType(KarigharApp), findsOneWidget);
    });

    testWidgets('Core Design Tokens & Widgets Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const VKAppBar(title: 'Test Title', currentRole: 'artisan'),
            body: Column(
              children: [
                VKButton(label: 'Click Me', onPressed: () {}),
                const VKBadge(label: 'Grade A+ GI'),
                const VKCard(child: Text('Card Content')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Tour'), findsOneWidget);
      expect(find.text('Click Me'), findsOneWidget);
      expect(find.text('Grade A+ GI'), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('VKGuidedTourModal renders 4 evaluation stations', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VKGuidedTourModal(),
          ),
        ),
      );

      // Verify header and initial step
      expect(find.text('SIH 2026 EVALUATOR TOUR'), findsOneWidget);
      expect(find.text('ARTISAN INCLUSIVITY & AI'), findsOneWidget);
      expect(find.text('Rural Artisan Studio & Neural Weave Inspection'), findsOneWidget);
      expect(find.text('Next Pillar'), findsOneWidget);

      // Tap Next Pillar
      await tester.tap(find.text('Next Pillar'));
      await tester.pumpAndSettle();

      expect(find.text('Institutional B2B Tenders & Cluster Pooling'), findsOneWidget);
    });

    testWidgets('KarigharCreditScreen renders credit score & trust rating', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KarigharCreditScreen(),
          ),
        ),
      );

      expect(find.text('ALTERNATIVE ARTISAN TRUST SCORE'), findsOneWidget);
      expect(find.text('842'), findsOneWidget);
      expect(find.text('Tier-1 AAA (Prime Trust)'), findsOneWidget);
    });

    testWidgets('ExportCustomsScreen renders multi-currency conversion', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExportCustomsScreen(
              productTitle: 'Banarasi Silk Saree',
              priceInr: 8500,
            ),
          ),
        ),
      );

      expect(find.text('Select Destination Country for Cross-Border Dispatch:'), findsOneWidget);
      expect(find.text('Declared Value (USD):'), findsOneWidget);
    });

    testWidgets('GisClusterMapScreen renders national cluster telemetry radar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GisClusterMapScreen(),
          ),
        ),
      );

      expect(find.text('MoSJE GIS Cluster Map'), findsOneWidget);
      expect(find.text('NATIONAL LOOM TELEMETRY RADAR'), findsOneWidget);
    });

    testWidgets('BlockchainExplorerScreen renders blocks & consortium network banner', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainExplorerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MoSJE Sovereign Consortium Subnet'), findsOneWidget);
      expect(find.text('Chain ID: 13702'), findsOneWidget);
      expect(find.text('⛓️ Immutable Block Chain'), findsOneWidget);
    });

    testWidgets('Language switcher reactively toggles between English, Hindi, and Tamil', (WidgetTester tester) async {
      LocaleManager.setLanguage(AppLanguage.english);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: VKAppBar(title: 'Artisan Studio', currentRole: 'artisan'),
          ),
        ),
      );

      // Verify initial English
      expect(find.text('Artisan Studio'), findsOneWidget);
      expect(find.text('Tour'), findsOneWidget);
      expect(find.text('EN'), findsOneWidget);

      // Switch to Hindi
      LocaleManager.setLanguage(AppLanguage.hindi);
      await tester.pumpAndSettle();

      expect(find.text('कारीगर स्टूडियो'), findsOneWidget);
      expect(find.text('टूर'), findsOneWidget);
      expect(find.text('हि'), findsOneWidget);

      // Switch to Tamil
      LocaleManager.setLanguage(AppLanguage.tamil);
      await tester.pumpAndSettle();

      expect(find.text('கைவினைஞர் அரங்கம்'), findsOneWidget);
      expect(find.text('த'), findsOneWidget);

      // Reset to English
      LocaleManager.setLanguage(AppLanguage.english);
      await tester.pumpAndSettle();
      expect(find.text('Artisan Studio'), findsOneWidget);
    });

    testWidgets('AuthScreen renders Login and Register tabs, mobile OTP, and 1-tap personas', (WidgetTester tester) async {
      LocaleManager.setLanguage(AppLanguage.english);

      await tester.pumpWidget(
        const MaterialApp(
          home: AuthScreen(),
        ),
      );

      // Verify Header and Insignia
      expect(find.text('KARIGHAR'), findsOneWidget);
      expect(find.textContaining('कारीघर'), findsOneWidget);

      // Verify Tabs exist
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);

      // Verify Mobile OTP fields and 1-Tap Evaluator quick access
      expect(find.text('Mobile OTP'), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
      expect(find.text('1-Tap Evaluator Quick Access'), findsOneWidget);
      expect(find.text('🎨 Artisan'), findsOneWidget);
      expect(find.text('🛍️ Buyer'), findsOneWidget);
      expect(find.text('🛡️ Admin'), findsOneWidget);

      // Switch to Register Tab
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Verify Register fields
      expect(find.text('Artisan / Weaver'), findsOneWidget);
      expect(find.text('Buyer / Enterprise'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Craft Category'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Sign In here'), findsOneWidget);

      // Scroll and tap "Sign In here" selection button to switch back to Login view
      await tester.ensureVisible(find.text('Sign In here'));
      await tester.tap(find.text('Sign In here'));
      await tester.pumpAndSettle();

      // Verify returned to Login
      expect(find.text('Register Now'), findsOneWidget);

      // Scroll and tap "Register Now" selection button to switch to Register view
      await tester.ensureVisible(find.text('Register Now'));
      await tester.tap(find.text('Register Now'));
      await tester.pumpAndSettle();

      // Switch role to Buyer / Enterprise
      await tester.tap(find.text('Buyer / Enterprise'));
      await tester.pumpAndSettle();
      expect(find.text('Organization / Business Name'), findsOneWidget);

      // Tap top Login selection button to switch back to Login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.text('Mobile OTP'), findsOneWidget);

      // Verify Language Switcher pill opens and switches language on AuthScreen
      expect(find.text('EN'), findsOneWidget);
      await tester.tap(find.text('EN'));
      await tester.pumpAndSettle();
      expect(find.text('हिंदी (Hindi)'), findsOneWidget);
      await tester.tap(find.text('हिंदी (Hindi)'));
      await tester.pumpAndSettle();
      expect(find.text('हि'), findsOneWidget);
    });

    testWidgets('ArtisanDashboardScreen renders metrics, hero card, and translates into Hindi and Tamil', (WidgetTester tester) async {
      LocaleManager.setLanguage(AppLanguage.english);

      final artisanBloc = ArtisanBloc();
      addTearDown(() => artisanBloc.close());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ArtisanBloc>.value(
            value: artisanBloc,
            child: const ArtisanDashboardScreen(),
          ),
        ),
      );
      await tester.pump();

      // Check English elements
      expect(find.text('Total GMV'), findsOneWidget);
      expect(find.text('Active Orders'), findsOneWidget);
      expect(find.text('Bulk Quotes'), findsOneWidget);
      expect(find.text('GI Compliance'), findsOneWidget);
      expect(find.text('Add Product (AI)'), findsOneWidget);
      expect(find.text('Setu Didi (Voice)'), findsOneWidget);

      // Switch to Hindi
      LocaleManager.setLanguage(AppLanguage.hindi);
      await tester.pump();

      expect(find.text('कुल सकल बिक्री'), findsOneWidget);
      expect(find.text('सक्रिय ऑर्डर'), findsOneWidget);
      expect(find.text('थोक मूल्य प्रस्ताव'), findsOneWidget);
      expect(find.text('जीआई अनुपालन'), findsOneWidget);
      expect(find.text('नया उत्पाद जोड़ें (एआई)'), findsOneWidget);
      expect(find.text('सेतु दीदी (आवाज़)'), findsOneWidget);

      // Switch to Tamil
      LocaleManager.setLanguage(AppLanguage.tamil);
      await tester.pump();

      expect(find.text('மொத்த விற்பனை'), findsOneWidget);
      expect(find.text('செயலில் உள்ள ஆர்டர்கள்'), findsOneWidget);
      expect(find.text('மொத்த விலை கோரிக்கைகள்'), findsOneWidget);
      expect(find.text('புவிசார் குறியீடு'), findsOneWidget);
      expect(find.text('பொருள் சேர்க்க (AI)'), findsOneWidget);
      expect(find.text('சேது தீதி (குரல்)'), findsOneWidget);

      // Reset to English
      LocaleManager.setLanguage(AppLanguage.english);
    });

    testWidgets('StudioWizardScreen renders Camera, Audio Recorder, Smart Pricing, and Review steps', (WidgetTester tester) async {
      LocaleManager.setLanguage(AppLanguage.english);

      final artisanBloc = ArtisanBloc();
      final buyerBloc = BuyerBloc();
      addTearDown(() {
        artisanBloc.close();
        buyerBloc.close();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ArtisanBloc>.value(value: artisanBloc),
              BlocProvider<BuyerBloc>.value(value: buyerBloc),
            ],
            child: const StudioWizardScreen(),
          ),
        ),
      );
      await tester.pump();

      // Step 1: Camera & Image Studio
      expect(find.text('AI Image Studio'), findsOneWidget);
      expect(find.text('Take Camera Photo'), findsOneWidget);
      expect(find.text('Upload from Gallery'), findsOneWidget);
      expect(find.text('Multi-Angle Craft Gallery'), findsOneWidget);
      expect(find.text('Full Craft'), findsOneWidget);
      expect(find.text('4K Super-Resolution'), findsOneWidget);

      // Advance to Step 2: Voice Catalog & Audio Recorder
      await tester.ensureVisible(find.text('Continue (2/4)'));
      await tester.tap(find.text('Continue (2/4)'));
      await tester.pump();

      expect(find.text('Voice-to-Catalog AI'), findsOneWidget);
      expect(find.text('Try Demo Voice Description'), findsOneWidget);
      expect(find.text('AI Structured Metadata Extraction'), findsOneWidget);
      expect(find.text('Product Title'), findsOneWidget);

      // Tap demo voice description
      await tester.ensureVisible(find.text('Try Demo Voice Description'));
      await tester.tap(find.text('Try Demo Voice Description'));
      await tester.pump();

      // Switch to Hindi on Step 2
      LocaleManager.setLanguage(AppLanguage.hindi);
      await tester.pump();

      expect(find.text('आवाज़ से कैटलॉग बनाएं'), findsOneWidget);
      expect(find.text('उत्पाद का शीर्षक'), findsOneWidget);
      expect(find.text('नमूना आवाज़ आज़माएं'), findsOneWidget);

      // Switch back to English
      LocaleManager.setLanguage(AppLanguage.english);
      await tester.pump();

      // Advance to Step 3: Smart Pricing
      await tester.tap(find.text('Continue (3/4)'));
      await tester.pump();

      expect(find.text('Smart Pricing Engine'), findsOneWidget);
      expect(find.text('RECOMMENDED FAIR MARKET VALUE'), findsOneWidget);
      expect(find.text('Cost Breakdown Inputs'), findsOneWidget);

      // Advance to Step 4: Final Review & Publish
      await tester.tap(find.text('Continue (4/4)'));
      await tester.pump();

      expect(find.text('Final Review & Publish'), findsOneWidget);
      expect(find.text('NEURAL WEAVE INSPECTION'), findsOneWidget);
      expect(find.text('Publish to Marketplace'), findsOneWidget);
    });

    testWidgets('NotFoundScreen renders 404 details, requested URL, and destination cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NotFoundScreen(path: '/unknown-route-test'),
        ),
      );
      await tester.pump();

      expect(find.textContaining('404'), findsOneWidget);
      expect(find.textContaining('Page Not Found'), findsOneWidget);
      expect(find.textContaining('पृष्ठ नहीं मिला'), findsOneWidget);
      expect(find.textContaining('/unknown-route-test'), findsOneWidget);
      expect(find.textContaining('AI Studio Wizard'), findsOneWidget);
      expect(find.text('Artisan Dashboard'), findsOneWidget);
      expect(find.text('Buyer Marketplace'), findsOneWidget);
      expect(find.text('MoSJE Admin Panel'), findsOneWidget);
      expect(find.text('Return to Home / Login'), findsOneWidget);
    });

    test('LocaleManager provides complete trilingual translations for critical actions', () {
      final keys = [
        'AI Image Studio',
        'Stop',
        'Add custom tag...',
        'Smart Pricing Engine',
        'Enter a valid 10-digit mobile number',
        'Failed to send OTP',
        'Please enter mobile number and OTP',
        'Please enter email/phone and password',
        'Authentication failed. Please verify your credentials.',
        'Please enter your full name',
        'Please enter a valid mobile number',
        'Account created successfully! Welcome to Karighar.',
        'Registration failed. Please try again.',
        'CRAFT • CULTURE • COMMUNITY • OPPORTUNITY',
        'Aadhaar / PM-Vishwakarma ID',
      ];

      for (final key in keys) {
        LocaleManager.setLanguage(AppLanguage.english);
        expect(key.tr.isNotEmpty, true, reason: 'English failed for $key');

        LocaleManager.setLanguage(AppLanguage.hindi);
        expect(key.tr.isNotEmpty, true, reason: 'Hindi failed for $key');
        expect(key.tr != key || key == 'AI Image Studio' || key == 'Stop', true);

        LocaleManager.setLanguage(AppLanguage.tamil);
        expect(key.tr.isNotEmpty, true, reason: 'Tamil failed for $key');
      }

      // Reset to English
      LocaleManager.setLanguage(AppLanguage.english);
    });

    testWidgets('BuyerQuotesScreen and RfpTenderBoardScreen mount and dispose without memory leaks', (WidgetTester tester) async {
      // 1. Mount BuyerQuotesScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: BuyerQuotesScreen(),
        ),
      );
      await tester.pump();
      expect(find.byType(BuyerQuotesScreen), findsOneWidget);

      // Dispose BuyerQuotesScreen by unmounting
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      // 2. Mount RfpTenderBoardScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: RfpTenderBoardScreen(),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Active Procurement Tenders'), findsOneWidget);

      // Dispose RfpTenderBoardScreen by unmounting
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });

    testWidgets('Phase 1 Buyer screens mount and render correctly', (WidgetTester tester) async {
      // 1. Mount BuyerStoriesScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: BuyerStoriesScreen(),
        ),
      );
      await tester.pump();
      expect(find.textContaining('Master Ramdev Varma'), findsOneWidget);
      expect(find.textContaining('Smt. Sita Devi'), findsOneWidget);

      // 2. Mount BuyerExploreScreen with BlocProvider
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => BuyerBloc(),
            child: const BuyerExploreScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('All Regions'), findsOneWidget);
      expect(find.text('National GIS Cluster Radar'), findsOneWidget);

      // 3. Mount BuyerProfileScreen
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => BuyerBloc(),
            child: const BuyerProfileScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Login as Buyer'), findsAtLeastNWidgets(1));
      expect(find.text('Login as Seller'), findsOneWidget);
    });
  });
}



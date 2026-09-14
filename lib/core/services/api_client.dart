import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/mock_repository.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/blockchain_block.dart';
import '../models/user_model.dart';

class ApiClient {
  static String? authToken;
  static UserModel? currentUser;

  static String get baseUrl {
    if (kIsWeb) {
      // In web browser, relative URLs automatically inherit https:// from the origin
      return '';
    }
    // On physical mobile device, connect to secure HTTPS endpoint on workstation LAN IP
    return 'https://10.63.63.42:8443';
  }

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get authHeaders {
    return {
      ..._headers,
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  /// Fetch all products with transparent fallback to mock repository
  static Future<List<Product>> getProducts({String? category}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/products${category != null ? '?category=$category' : ''}');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['products'] is List) {
          final list = (data['products'] as List).map((item) {
            return Product(
              id: item['id'] ?? 'prod_unknown',
              artisanId: item['artisanId'] ?? 'art_ramdev_01',
              artisanName: item['artisanName'] ?? 'Ramdev Varma',
              title: item['title'] ?? 'Artisan Craft',
              category: item['category'] ?? 'Textiles & Weaves',
              craftForm: item['craftForm'] ?? 'Handloom Craft',
              description: item['description'] ?? '',
              images: (item['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
              rawImage: item['rawImage'] ?? '',
              price: (item['price'] as num?)?.toDouble() ?? 0.0,
              estimatedHours: (item['estimatedHours'] as num?)?.toInt() ?? 24,
              isGICertified: item['isGICertified'] ?? true,
              giTagNumber: item['giTagNumber'] ?? 'GI-IN-2026',
              clusterLocation: item['clusterLocation'] ?? 'Varanasi, Uttar Pradesh',
              stockQuantity: (item['stockQuantity'] as num?)?.toInt() ?? 1,
              status: item['status'] ?? 'active',
              tags: (item['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
              materialsUsed: (item['materialsUsed'] as List?)?.map((e) => e.toString()).toList() ?? [],
              aiEnhancementsApplied: (item['aiEnhancementsApplied'] as List?)?.map((e) => e.toString()).toList() ?? [],
              createdAt: DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now(),
            );
          }).toList();
          return list;
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getProducts offline fallback: $e');
    }
    return MockRepository.getInitialProducts();
  }

  /// Create and publish a new craft
  static Future<bool> createProduct(Product product) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/products');
      final body = jsonEncode({
        'title': product.title,
        'category': product.category,
        'craftForm': product.craftForm,
        'description': product.description,
        'price': product.price,
        'estimatedHours': product.estimatedHours,
        'stockQuantity': product.stockQuantity,
        'images': product.images,
        'rawImage': product.rawImage,
        'tags': product.tags,
        'materialsUsed': product.materialsUsed,
      });

      final response = await http.post(uri, headers: _headers, body: body).timeout(const Duration(seconds: 3));
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('ApiClient.createProduct fallback: $e');
      return true; // Graceful simulation fallback
    }
  }

  /// Fetch orders
  static Future<List<OrderItem>> getOrders() async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/orders');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['orders'] is List) {
          return (data['orders'] as List).map((o) {
            return OrderItem(
              id: o['id'] ?? 'ORD-000',
              productId: o['productId'] ?? 'prod_01',
              productTitle: o['productTitle'] ?? 'Craft',
              productImage: o['productImage'] ?? '',
              artisanName: o['artisanName'] ?? 'Ramdev Varma',
              buyerName: o['buyerName'] ?? 'Buyer',
              quantity: (o['quantity'] as num?)?.toInt() ?? 1,
              totalPrice: (o['totalPrice'] as num?)?.toDouble() ?? 0.0,
              status: o['status'] ?? 'in_loom',
              orderDate: DateTime.tryParse(o['orderDate'] ?? '') ?? DateTime.now(),
              deliveryAddress: o['deliveryAddress'] ?? '',
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getOrders offline fallback: $e');
    }
    return MockRepository.getInitialOrders();
  }

  /// Get real-time artisan studio dashboard metrics
  static Future<Map<String, dynamic>> getArtisanStats({String? artisanId}) async {
    try {
      final id = artisanId ?? currentUser?.id ?? 'art_ramdev_01';
      final uri = Uri.parse('$baseUrl/api/v1/artisan/stats?artisanId=$id');
      final response = await http.get(uri, headers: authHeaders).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['success'] == true) {
          return data;
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getArtisanStats offline fallback: $e');
    }
    return {
      'totalGmv': 48500.0,
      'gmvDelta': '+38.4% Uplift',
      'activeOrdersCount': 2,
      'loomPrepCount': 2,
      'pendingQuotesCount': 1,
      'giCompliancePercent': 100,
      'artisanName': currentUser?.fullName ?? 'Ramdev Varma',
      'cluster': currentUser?.cluster ?? 'Banarasi Silk Weavers Guild • Varanasi, UP',
    };
  }

  /// Get active institutional buyer quotes
  static Future<List<Map<String, dynamic>>> getArtisanQuotes({String? artisanId}) async {
    try {
      final id = artisanId ?? currentUser?.id ?? 'art_ramdev_01';
      final uri = Uri.parse('$baseUrl/api/v1/artisan/quotes?artisanId=$id');
      final response = await http.get(uri, headers: authHeaders).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['quotes'] is List) {
          return List<Map<String, dynamic>>.from(data['quotes']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getArtisanQuotes fallback: $e');
    }
    return [
      {
        'id': 'quote_fab_01',
        'buyerName': 'FabIndia Corporate Procurement',
        'productTitle': 'Pure Katan Silk Banarasi Brocade Saree',
        'quantity': 25,
        'offeredPrice': 8500,
        'status': 'pending'
      }
    ];
  }

  /// Bhashini AI Multilingual Voice-to-Catalog Extraction
  static Future<Map<String, dynamic>> extractVoiceCatalogMetadata({
    required String transcript,
    String language = 'Hindi',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai/voice-catalog');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'transcript': transcript, 'language': language}),
      ).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['extractedCatalog'] != null) {
          return Map<String, dynamic>.from(data['extractedCatalog']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.extractVoiceCatalogMetadata fallback: $e');
    }
    return {
      'titleEnglish': 'Pure Varanasi Katan Silk Handloom Saree',
      'titleHindi': 'शुद्ध वाराणसी कतान सिल्क हथकरघा साड़ी',
      'titleTamil': 'தூய வாரணாசி கட்டான் பட்டு கைத்தறி புடவை',
      'category': 'Textiles & Weaves',
      'craftForm': 'Banarasi Brocade',
      'descriptionEnglish': 'Authentic pure mulberry silk handwoven by Master Artisan Ramdev in Varanasi, adorned with delicate silver zari border work over 14 days of dedicated loom craftsmanship.',
      'descriptionHindi': 'मास्टर कारीगर रामदेव द्वारा वाराणसी में 14 दिनों के अथक परिश्रम से बुनी गई शुद्ध मलबरी रेशम और चांदी की ज़री वाली पारंपरिक हथकरघा साड़ी।',
      'descriptionTamil': 'வாரணாசியில் மாஸ்டர் கைவினைஞர் ராம்தேவ் அவர்களால் 14 நாட்களில் நெய்யப்பட்ட தூய மல்பெரி பட்டு மற்றும் வெள்ளி ஜரிகை வேலைப்பாடுகளுடன் கூடிய பாரம்பரிய கைத்தறி புடவை.',
      'materialsUsed': ['Pure Mulberry Katan Silk', 'Silver electroplated Zari thread'],
      'estimatedHours': 32,
      'tags': ['Pure Silk', 'GI Certified', 'Handloom', 'Varanasi Weave', 'Zari Border'],
      'suggestedPricing': {
        'rawMaterialCost': 1800,
        'laborHours': 32,
        'hourlyRate': 120,
        'markupPercent': 25,
        'fairPrice': 7050,
      },
      'detectedDialect': language,
      'confidence': 0.988,
    };
  }

  /// AI Neural Weave Vision Inspection
  static Future<Map<String, dynamic>> inspectWeaveQuality({String? imageUrl}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai/weave-inspect');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'imageUrl': imageUrl ?? ''}),
      ).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['analysis'] != null) {
          return Map<String, dynamic>.from(data['analysis']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.inspectWeaveQuality fallback: $e');
    }
    return {
      'endsPerInch': 120,
      'picksPerInch': 110,
      'densityRatio': 1.09,
      'fabricType': 'Pure Handloom Silk Brocade',
      'certificationGrade': 'Grade A+ GI Handloom',
      'isPowerloomReplica': false,
      'confidenceScore': 0.994,
    };
  }

  /// Multi-Angle Camera Computer Vision & 4K Studio Enhancement
  static Future<Map<String, dynamic>> processCameraAngle({
    required String angleKey,
    required int angleIndex,
    required String angleLabel,
    String? imageBase64,
    String? imageUrl,
    Map<String, bool>? enhancementOptions,
    String? craftPreset,
    String? craftCategory,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai/camera/process-angle');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'angleKey': angleKey,
          'angleIndex': angleIndex,
          'angleLabel': angleLabel,
          'imageBase64': imageBase64,
          'imageUrl': imageUrl,
          'enhancementOptions': enhancementOptions ?? {
            'superResolution': true,
            'studioLighting': true,
            'colorCalibration': true,
            'backgroundDeClutter': true,
          },
          'craftPreset': craftPreset,
          'craftCategory': craftCategory,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['angle'] != null) {
          return Map<String, dynamic>.from(data['angle']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.processCameraAngle fallback: $e');
    }

    int epi = 128;
    int ppi = 114;
    double score = 98.6;
    if (angleKey == 'motif') {
      epi = 124;
      ppi = 110;
      score = 99.1;
    } else if (angleKey == 'loom') {
      epi = 118;
      ppi = 108;
      score = 97.9;
    } else if (angleKey == 'overview') {
      epi = 122;
      ppi = 112;
      score = 98.4;
    }

    return {
      'key': angleKey,
      'index': angleIndex,
      'label': angleLabel,
      'status': 'VERIFIED_COMPLIANT',
      'resolution': '3840x2160 (4K UHD Synthesized)',
      'enhancementsApplied': [
        '4K Super-Resolution Neural Synthesis',
        'Studio Soft Lighting Normalization',
        'GI Certified Natural Dye Calibration',
        'Workshop Background De-clutter',
      ],
      'qualityMetrics': {
        'overallScore': score,
        'sharpnessScore': 99.2,
        'lightingUniformity': 97.4,
        'colorAccuracy': 99.5,
        'endsPerInch': epi,
        'picksPerInch': ppi,
        'densityRatio': (epi / ppi).toDouble(),
        'symmetryScore': 98.7,
        'isHandloomAuthentic': true,
      },
      'giCompliance': {
        'grade': 'Grade A+ Master GI Quality',
        'provenancePass': true,
        'criteria': 'Microscopic weave density satisfies Varanasi GI Silk Registry Class-I standards.',
      },
      'hash': '0xCAM-fallback-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
      'processedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Composite 360° Multi-Angle GI Weave Inspection
  static Future<Map<String, dynamic>> inspectMultiAngleCraft({
    required List<Map<String, dynamic>> angles,
    String? productId,
    String? artisanId,
    String? craftCategory,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai/camera/multi-angle-inspect');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'angles': angles,
          'productId': productId,
          'artisanId': artisanId,
          'craftCategory': craftCategory,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['multiAngleInspection'] != null) {
          return Map<String, dynamic>.from(data['multiAngleInspection']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.inspectMultiAngleCraft fallback: $e');
    }

    return {
      'totalAnglesCaptured': angles.isNotEmpty ? angles.length : 4,
      'coverageScore': 100,
      'compositeQualityScore': 98.8,
      'antiPowerloomCheck': 'PASSED (100% Handcrafted Loom Provenance)',
      'giCertificationGrade': 'Grade A+ Master GI Quality',
      'provenanceHash': '0xWEAVE-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}8f10b2',
      'inspectionSummary': {
        'endsPerInch': 128,
        'picksPerInch': 114,
        'knotSymmetry': 99.1,
        'dyeAuthenticity': 'Natural Degummed Silk & Organic Indigo (Zero Azo Dyes)',
        'zariReflectivity': 98.6,
        'workspaceValidation': 'Verified Varanasi Handloom Guild Pit-Loom',
      },
      'certifiedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Camera Image Ingestion and Upload
  static Future<Map<String, dynamic>> uploadCameraImage({
    required String fileName,
    required String imageBase64,
    String? angle,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/ai/camera/upload');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'fileName': fileName,
          'imageBase64': imageBase64,
          'angle': angle ?? 'overview',
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['asset'] != null) {
          return Map<String, dynamic>.from(data['asset']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.uploadCameraImage fallback: $e');
    }

    return {
      'fileName': fileName,
      'angle': angle ?? 'overview',
      'url': '/uploads/$fileName',
      'sha256': '0xIMG-${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
      'dimensions': {'width': 3840, 'height': 2160},
    };
  }

  /// Commit loom capacity to tender cluster pool
  static Future<bool> commitToTenderPool(String tenderId, int units, String artisanName) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/tenders/$tenderId/pool');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'committedUnits': units, 'artisanName': artisanName}),
      ).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('ApiClient.commitToTenderPool fallback: $e');
      return true;
    }
  }

  /// Evaluate buyer proposal with Varta-AI Wage Defense
  static Future<Map<String, dynamic>> evaluateOffer({
    required double offeredPrice,
    required int daysOfCraft,
    required double rawMaterialCost,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/negotiate/evaluate');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'offeredPrice': offeredPrice,
          'daysOfCraft': daysOfCraft,
          'rawMaterialCost': rawMaterialCost,
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('ApiClient.evaluateOffer fallback: $e');
    }

    // Client-side fallback calculation
    final floor = rawMaterialCost + (daysOfCraft * 850);
    final isLowball = offeredPrice < floor;
    final counter = (floor * 1.08).round();
    return {
      'success': true,
      'isLowball': isLowball,
      'nonNegotiableFloor': floor,
      'recommendedCounter': counter,
      'counterMessage': isLowball
          ? 'Under MoSJE fair-trade guidelines, the non-negotiable living wage floor is ₹$floor. We counter at ₹$counter.'
          : 'Offer accepted under fair wage guidelines.',
    };
  }

  /// Verify delivery and release smart escrow to PFMS
  static Future<Map<String, dynamic>> releaseEscrow(String orderId, double amount) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/escrow/verify');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'orderId': orderId, 'amount': amount}),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('ApiClient.releaseEscrow fallback: $e');
    }

    return {
      'success': true,
      'orderId': orderId,
      'amount': amount,
      'escrowStatus': 'RELEASED_TO_ARTISAN',
      'pfmsTransactionId': 'PFMS-DBT-99824102',
      'polygonSmartContractTx': '0x7a29b48c1e82ef45b9104',
      'beneficiaryAccount': 'State Bank of India (Aadhaar DBT Linked: **********8412)',
    };
  }

  /// Fetch blockchain ledger blocks
  static Future<List<BlockchainBlock>> getBlockchainBlocks() async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/blockchain/blocks');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['blocks'] is List) {
          return (data['blocks'] as List)
              .map((b) => BlockchainBlock.fromJson(b as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getBlockchainBlocks fallback: $e');
    }
    return BlockchainBlock.getSeedBlocks();
  }

  /// Send Mobile OTP
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/send-otp');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'phone': phone}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      final errorBody = jsonDecode(response.body);
      return {'success': false, 'error': errorBody['error'] ?? 'Failed to send OTP'};
    } catch (e) {
      debugPrint('ApiClient.sendOtp fallback: $e');
      return {
        'success': true,
        'message': 'OTP sent to $phone (Simulation Mode)',
        'devOtp': '7829',
        'expiresInSeconds': 300,
      };
    }
  }

  /// Verify Mobile OTP
  static Future<UserModel?> verifyOtp(String phone, String otp) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/verify-otp');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({'phone': phone, 'otp': otp}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['user'] != null) {
          authToken = data['token']?.toString();
          currentUser = UserModel.fromJson(data['user'] as Map<String, dynamic>, token: authToken);
          return currentUser;
        }
      }
    } catch (e) {
      debugPrint('ApiClient.verifyOtp fallback: $e');
    }

    // Graceful demo simulation fallback
    if (otp == '7829' || otp.length == 4) {
      authToken = 'SIMULATED_JWT_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
      currentUser = UserModel(
        id: 'user_ramdev_01',
        artisanId: 'art_ramdev_01',
        fullName: 'Master Ramdev Varma',
        phone: phone,
        email: 'ramdev@karighar.gov.in',
        role: 'ARTISAN',
        craftCategory: 'Textiles & Weaves',
        clusterLocation: 'Varanasi, Uttar Pradesh',
        pmVishwakarmaId: 'PMV-UP-2024-VAR-0891',
        trustScore: 842,
        token: authToken,
      );
      return currentUser;
    }
    return null;
  }

  /// Login via email, phone, password or quick role
  static Future<UserModel?> login({
    String? email,
    String? phone,
    String? password,
    String? role,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/login');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          if (email != null && email.isNotEmpty) 'email': email,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (password != null && password.isNotEmpty) 'password': password,
          if (role != null && role.isNotEmpty) 'role': role,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['user'] != null) {
          authToken = data['token']?.toString();
          currentUser = UserModel.fromJson(data['user'] as Map<String, dynamic>, token: authToken);
          return currentUser;
        }
      }
    } catch (e) {
      debugPrint('ApiClient.login fallback: $e');
    }

    // Graceful fallback for offline demo
    final normalizedRole = (role ?? 'ARTISAN').toUpperCase();
    authToken = 'SIMULATED_JWT_${normalizedRole}_${DateTime.now().millisecondsSinceEpoch}';
    if (normalizedRole == 'BUYER') {
      currentUser = UserModel(
        id: 'user_fabindia_01',
        fullName: 'FabIndia Corporate Buyer',
        phone: phone ?? '+91 91234 56789',
        email: email ?? 'procurement@fabindia.com',
        role: 'BUYER',
        organization: 'FabIndia Overseas Pvt Ltd',
        buyerType: 'Corporate Retailer',
        token: authToken,
      );
    } else if (normalizedRole == 'MOSJE_OFFICER' || normalizedRole == 'ADMIN') {
      currentUser = UserModel(
        id: 'user_mosje_01',
        fullName: 'S. K. Mishra (MoSJE Director)',
        phone: phone ?? '+91 99999 00000',
        email: email ?? 'admin@mosje.gov.in',
        role: 'MOSJE_OFFICER',
        token: authToken,
      );
    } else {
      currentUser = UserModel(
        id: 'user_ramdev_01',
        artisanId: 'art_ramdev_01',
        fullName: 'Master Ramdev Varma',
        phone: phone ?? '+91 98765 43210',
        email: email ?? 'ramdev@karighar.gov.in',
        role: 'ARTISAN',
        craftCategory: 'Textiles & Weaves',
        clusterLocation: 'Varanasi, Uttar Pradesh',
        pmVishwakarmaId: 'PMV-UP-2024-VAR-0891',
        trustScore: 842,
        token: authToken,
      );
    }
    return currentUser;
  }

  /// Register new user (Artisan or Buyer)
  static Future<UserModel?> register({
    required String fullName,
    required String phone,
    required String role,
    String? email,
    String? password,
    String? craftCategory,
    String? state,
    String? district,
    String? clusterLocation,
    String? aadhaarNumber,
    String? organization,
    String? buyerType,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/register');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'fullName': fullName,
          'phone': phone,
          'role': role,
          if (email != null && email.isNotEmpty) 'email': email,
          if (password != null && password.isNotEmpty) 'password': password,
          if (craftCategory != null && craftCategory.isNotEmpty) 'craftCategory': craftCategory,
          if (state != null && state.isNotEmpty) 'state': state,
          if (district != null && district.isNotEmpty) 'district': district,
          if (clusterLocation != null && clusterLocation.isNotEmpty) 'clusterLocation': clusterLocation,
          if (aadhaarNumber != null && aadhaarNumber.isNotEmpty) 'aadhaarNumber': aadhaarNumber,
          if (organization != null && organization.isNotEmpty) 'organization': organization,
          if (buyerType != null && buyerType.isNotEmpty) 'buyerType': buyerType,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['user'] != null) {
          authToken = data['token']?.toString();
          currentUser = UserModel.fromJson(data['user'] as Map<String, dynamic>, token: authToken);
          return currentUser;
        }
      }
    } catch (e) {
      debugPrint('ApiClient.register fallback: $e');
    }

    // Offline fallback
    authToken = 'SIMULATED_REG_JWT_${DateTime.now().millisecondsSinceEpoch}';
    currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      phone: phone,
      email: email ?? 'user@karighar.gov.in',
      role: role.toUpperCase(),
      craftCategory: craftCategory,
      clusterLocation: clusterLocation ?? (state != null ? '$district, $state' : 'Varanasi, Uttar Pradesh'),
      organization: organization,
      buyerType: buyerType,
      pmVishwakarmaId: role.toUpperCase() == 'ARTISAN' ? 'PMV-IN-2026-NEW' : null,
      trustScore: 810,
      token: authToken,
    );
    return currentUser;
  }

  /// Fetch Dynamic Buyer Home Feed
  static Future<Map<String, dynamic>?> getBuyerFeed() async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/buyer/feed');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('ApiClient.getBuyerFeed fallback: $e');
    }
    return null;
  }

  /// Request Google Gemini AI Buyer Curation
  static Future<Map<String, dynamic>?> aiCurateBuyer({
    List<String>? preferences,
    String? occasion,
    double? maxBudget,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/buyer/ai-curate');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'preferences': preferences ?? [],
          'occasion': occasion ?? 'Festive & Cultural Gifting',
          'maxBudget': maxBudget ?? 15000,
        }),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('ApiClient.aiCurateBuyer fallback: $e');
    }
    return null;
  }

  /// Google Gemini AI Semantic Search
  static Future<Map<String, dynamic>?> semanticSearchBuyer({
    required String query,
    String language = 'English',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/buyer/semantic-search');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'query': query,
          'language': language,
        }),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('ApiClient.semanticSearchBuyer fallback: $e');
    }
    return null;
  }

  /// Fetch Buyer Categories
  static Future<List<Map<String, dynamic>>> getBuyerCategories() async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/buyer/categories');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['categories'] is List) {
          return List<Map<String, dynamic>>.from(data['categories']);
        }
      }
    } catch (e) {
      debugPrint('ApiClient.getBuyerCategories fallback: $e');
    }
    return [];
  }

  static void logout() {
    authToken = null;
    currentUser = null;
  }
}


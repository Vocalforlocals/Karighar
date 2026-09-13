import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String artisanId;
  final String artisanName;
  final String title;
  final String category;
  final String craftForm;
  final String description;
  final List<String> images;
  final String rawImage;
  final double price;
  final int estimatedHours;
  final bool isGICertified;
  final String? giTagNumber;
  final String clusterLocation;
  final int stockQuantity;
  final String status;
  final List<String> tags;
  final List<String> materialsUsed;
  final List<String> aiEnhancementsApplied;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.artisanId,
    required this.artisanName,
    required this.title,
    required this.category,
    required this.craftForm,
    required this.description,
    required this.images,
    required this.rawImage,
    required this.price,
    required this.estimatedHours,
    required this.isGICertified,
    this.giTagNumber,
    required this.clusterLocation,
    required this.stockQuantity,
    required this.status,
    required this.tags,
    required this.materialsUsed,
    required this.aiEnhancementsApplied,
    required this.createdAt,
  });

  Product copyWith({
    String? id,
    String? artisanId,
    String? artisanName,
    String? title,
    String? category,
    String? craftForm,
    String? description,
    List<String>? images,
    String? rawImage,
    double? price,
    int? estimatedHours,
    bool? isGICertified,
    String? giTagNumber,
    String? clusterLocation,
    int? stockQuantity,
    String? status,
    List<String>? tags,
    List<String>? materialsUsed,
    List<String>? aiEnhancementsApplied,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      artisanId: artisanId ?? this.artisanId,
      artisanName: artisanName ?? this.artisanName,
      title: title ?? this.title,
      category: category ?? this.category,
      craftForm: craftForm ?? this.craftForm,
      description: description ?? this.description,
      images: images ?? this.images,
      rawImage: rawImage ?? this.rawImage,
      price: price ?? this.price,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      isGICertified: isGICertified ?? this.isGICertified,
      giTagNumber: giTagNumber ?? this.giTagNumber,
      clusterLocation: clusterLocation ?? this.clusterLocation,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      materialsUsed: materialsUsed ?? this.materialsUsed,
      aiEnhancementsApplied: aiEnhancementsApplied ?? this.aiEnhancementsApplied,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        artisanId,
        artisanName,
        title,
        category,
        craftForm,
        description,
        images,
        rawImage,
        price,
        estimatedHours,
        isGICertified,
        giTagNumber,
        clusterLocation,
        stockQuantity,
        status,
        tags,
        materialsUsed,
        aiEnhancementsApplied,
        createdAt,
      ];
}

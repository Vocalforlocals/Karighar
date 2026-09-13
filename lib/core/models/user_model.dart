import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? artisanId;
  final String fullName;
  final String phone;
  final String email;
  final String role; // 'ARTISAN', 'BUYER', 'MOSJE_OFFICER'
  final String? craftCategory;
  final String? clusterLocation;
  final String? organization;
  final String? buyerType;
  final String? pmVishwakarmaId;
  final int? trustScore;
  final String? token;

  const UserModel({
    required this.id,
    this.artisanId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.role,
    this.craftCategory,
    this.clusterLocation,
    this.organization,
    this.buyerType,
    this.pmVishwakarmaId,
    this.trustScore,
    this.token,
  });

  bool get isArtisan => role.toUpperCase() == 'ARTISAN';
  bool get isBuyer => role.toUpperCase() == 'BUYER';
  bool get isAdmin => role.toUpperCase() == 'MOSJE_OFFICER';
  String? get cluster => clusterLocation;

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      artisanId: json['artisanId']?.toString(),
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? 'User',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString().toUpperCase() ?? 'ARTISAN',
      craftCategory: json['craftCategory']?.toString(),
      clusterLocation: json['clusterLocation']?.toString(),
      organization: json['organization']?.toString(),
      buyerType: json['buyerType']?.toString(),
      pmVishwakarmaId: json['pmVishwakarmaId']?.toString(),
      trustScore: json['trustScore'] as int?,
      token: token ?? json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artisanId': artisanId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'role': role,
      'craftCategory': craftCategory,
      'clusterLocation': clusterLocation,
      'organization': organization,
      'buyerType': buyerType,
      'pmVishwakarmaId': pmVishwakarmaId,
      'trustScore': trustScore,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [
        id,
        artisanId,
        fullName,
        phone,
        email,
        role,
        craftCategory,
        clusterLocation,
        organization,
        buyerType,
        pmVishwakarmaId,
        trustScore,
        token,
      ];
}

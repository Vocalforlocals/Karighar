class ArtisanCreditProfile {
  final int creditScore; // 300 - 900
  final String ratingTier; // e.g. AAA Prime
  final double onTimeDeliveryRate; // %
  final double averageWeaveQuality; // %
  final double verifiedDbtTurnover; // in INR
  final double preApprovedLoanAmount; // e.g. 100000.0
  final double interestRatePerAnnum; // e.g. 5.0% under PM-Vishwakarma
  final int tenureMonths; // e.g. 18

  const ArtisanCreditProfile({
    required this.creditScore,
    required this.ratingTier,
    required this.onTimeDeliveryRate,
    required this.averageWeaveQuality,
    required this.verifiedDbtTurnover,
    required this.preApprovedLoanAmount,
    required this.interestRatePerAnnum,
    required this.tenureMonths,
  });
}

class CreditScoringService {
  static ArtisanCreditProfile getProfileForArtisan(String artisanId) {
    return const ArtisanCreditProfile(
      creditScore: 842,
      ratingTier: 'Tier-1 AAA (Prime Trust)',
      onTimeDeliveryRate: 97.8,
      averageWeaveQuality: 98.6,
      verifiedDbtTurnover: 182000.0,
      preApprovedLoanAmount: 100000.0,
      interestRatePerAnnum: 5.0,
      tenureMonths: 18,
    );
  }
}

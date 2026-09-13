import 'package:equatable/equatable.dart';

class RfpTender extends Equatable {
  final String id;
  final String buyerOrg;
  final String buyerContact;
  final String craftCategory;
  final String title;
  final String description;
  final int totalQuantityRequested;
  final double maxBudgetPerUnit;
  final String targetCluster;
  final DateTime deadline;
  final String status; // 'open', 'allocating', 'in_loom', 'fulfilled'
  final int allocatedArtisansCount;
  final double guaranteedFairWage;

  const RfpTender({
    required this.id,
    required this.buyerOrg,
    required this.buyerContact,
    required this.craftCategory,
    required this.title,
    required this.description,
    required this.totalQuantityRequested,
    required this.maxBudgetPerUnit,
    required this.targetCluster,
    required this.deadline,
    required this.status,
    required this.allocatedArtisansCount,
    required this.guaranteedFairWage,
  });

  @override
  List<Object?> get props => [
        id,
        buyerOrg,
        buyerContact,
        craftCategory,
        title,
        description,
        totalQuantityRequested,
        maxBudgetPerUnit,
        targetCluster,
        deadline,
        status,
        allocatedArtisansCount,
        guaranteedFairWage,
      ];
}

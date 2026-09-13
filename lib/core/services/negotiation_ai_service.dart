class NegotiationEvaluation {
  final bool isExploitative;
  final double minimumAcceptablePrice;
  final double suggestedCounterPrice;
  final String reasoning;
  final String suggestedReplyHindi;
  final String suggestedReplyEnglish;

  const NegotiationEvaluation({
    required this.isExploitative,
    required this.minimumAcceptablePrice,
    required this.suggestedCounterPrice,
    required this.reasoning,
    required this.suggestedReplyHindi,
    required this.suggestedReplyEnglish,
  });
}

class NegotiationAiService {
  static NegotiationEvaluation evaluateOffer({
    required double offeredPrice,
    required double catalogPrice,
    required int requestedQuantity,
    required int estimatedLoomHours,
  }) {
    // MoSJE guideline: Minimum fair artisan wage floor = ₹110/hour + raw material baseline (40% of catalog)
    final rawMaterialCost = catalogPrice * 0.40;
    final minimumLaborCompensation = estimatedLoomHours * 110.0;
    final minimumWageFloor = rawMaterialCost + minimumLaborCompensation;

    // Volume discount allowance: max 12% for bulk > 20 units
    final bulkDiscountPct = requestedQuantity >= 20 ? 0.12 : (requestedQuantity >= 10 ? 0.08 : 0.05);
    final suggestedCounter = (catalogPrice * (1.0 - bulkDiscountPct)).clamp(minimumWageFloor, catalogPrice);

    final isExploitative = offeredPrice < minimumWageFloor;

    String reasoning;
    String replyHi;
    String replyEn;

    if (isExploitative) {
      reasoning = 'The proposed offer (₹${offeredPrice.toStringAsFixed(0)}) is below the MoSJE minimum wage floor of ₹${minimumWageFloor.toStringAsFixed(0)}. Accepting would violate artisan labor rights.';
      replyHi = 'नमस्ते! यह 14-दिन की शुद्ध हथकरघा बुनाई है जिसमें $estimatedLoomHours घंटे का श्रम लगा है। सरकारी MoSJE नियमों के अनुसार न्यूनतम पारिश्रमिक ₹${minimumWageFloor.toStringAsFixed(0)} है। हम ₹${suggestedCounter.toStringAsFixed(0)} में $requestedQuantity पीस दे सकते हैं।';
      replyEn = 'Greetings! This handloom craft requires $estimatedLoomHours hours of skilled loom work. Under MoSJE Fair Wage regulations, the minimum floor is ₹${minimumWageFloor.toStringAsFixed(0)}. The best batch price we can offer is ₹${suggestedCounter.toStringAsFixed(0)} per unit.';
    } else {
      reasoning = 'The offer is above the minimum wage floor. A balanced counter-offer can close the deal profitably for the artisan cluster.';
      replyHi = 'आपके ₹${offeredPrice.toStringAsFixed(0)} के प्रस्ताव के लिए धन्यवाद। हम ₹${suggestedCounter.toStringAsFixed(0)} में इस थोक ऑर्डर को फाइनल करने के लिए तैयार हैं।';
      replyEn = 'Thank you for your offer of ₹${offeredPrice.toStringAsFixed(0)}. We can finalize this bulk order at ₹${suggestedCounter.toStringAsFixed(0)} per unit with guaranteed GI certification.';
    }

    return NegotiationEvaluation(
      isExploitative: isExploitative,
      minimumAcceptablePrice: minimumWageFloor,
      suggestedCounterPrice: suggestedCounter,
      reasoning: reasoning,
      suggestedReplyHindi: replyHi,
      suggestedReplyEnglish: replyEn,
    );
  }
}

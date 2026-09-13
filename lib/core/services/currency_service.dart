class CurrencyRate {
  final String code;
  final String symbol;
  final String name;
  final double inrRate; // e.g. 1 USD = 86.50 INR

  const CurrencyRate({
    required this.code,
    required this.symbol,
    required this.name,
    required this.inrRate,
  });
}

class CurrencyService {
  static const Map<String, CurrencyRate> supportedCurrencies = {
    'INR': CurrencyRate(code: 'INR', symbol: '₹', name: 'Indian Rupee', inrRate: 1.0),
    'USD': CurrencyRate(code: 'USD', symbol: '\$', name: 'US Dollar', inrRate: 86.50),
    'EUR': CurrencyRate(code: 'EUR', symbol: '€', name: 'Euro', inrRate: 91.20),
    'GBP': CurrencyRate(code: 'GBP', symbol: '£', name: 'British Pound', inrRate: 108.40),
    'AED': CurrencyRate(code: 'AED', symbol: 'AED ', name: 'UAE Dirham', inrRate: 23.55),
  };

  static String formatCurrency(double inrAmount, String targetCurrency) {
    final rateInfo = supportedCurrencies[targetCurrency] ?? supportedCurrencies['INR']!;
    final converted = inrAmount / rateInfo.inrRate;
    if (targetCurrency == 'INR') {
      return '${rateInfo.symbol}${inrAmount.toStringAsFixed(0)}';
    }
    return '${rateInfo.symbol}${converted.toStringAsFixed(2)}';
  }
}

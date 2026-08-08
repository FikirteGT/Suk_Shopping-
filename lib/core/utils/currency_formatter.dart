import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatWithDiscount(double amount, double discountPercent) {
    final discounted = amount * (1 - (discountPercent / 100));
    return format(discounted);
  }
}

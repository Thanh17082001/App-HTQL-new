import 'package:intl/intl.dart';

String formatCurency(String cur) {
  final curInt = int.parse(cur);
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  String formattedAmount = currencyFormat.format(curInt);
  return formattedAmount;
}

import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');

  /// 32.0 → "R$ 32,00"
  static String currency(double value) => _currency.format(value);

  /// "2024-12-31" → "31/12/2024"
  static String date(String iso) {
    final parts = iso.split('-');
    return parts.length == 3 ? '${parts[2]}/${parts[1]}/${parts[0]}' : 'Data indisponível';
  }
}

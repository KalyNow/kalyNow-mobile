extension StringExtension on String {
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  bool get isValidEmail =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(this);
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String get formattedDate => '$day/$month/$year';

  String get formattedDateTime =>
      '$day/$month/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

extension DoubleExtension on double {
  String get asCurrency => '\$${toStringAsFixed(2)}';
}

import 'package:flutter_test/flutter_test.dart';
import 'package:kalynow_mobile/shared/utils/extensions.dart';

void main() {
  group('StringExtension', () {
    test('capitalised returns capitalised string', () {
      expect('hello'.capitalised, 'Hello');
      expect('WORLD'.capitalised, 'WORLD');
      expect(''.capitalised, '');
    });

    test('isValidEmail returns true for valid emails', () {
      expect('user@example.com'.isValidEmail, isTrue);
      expect('user.name+tag@sub.domain.org'.isValidEmail, isTrue);
    });

    test('isValidEmail returns false for invalid emails', () {
      expect('not-an-email'.isValidEmail, isFalse);
      expect('@no-user.com'.isValidEmail, isFalse);
      expect(''.isValidEmail, isFalse);
    });
  });

  group('DateTimeExtension', () {
    test('isToday returns true for now', () {
      expect(DateTime.now().isToday, isTrue);
    });

    test('isToday returns false for yesterday', () {
      expect(
        DateTime.now().subtract(const Duration(days: 1)).isToday,
        isFalse,
      );
    });

    test('formattedDate returns d/m/yyyy', () {
      // Use an explicit historical date to keep the expected string stable.
      final date = DateTime(2020, 6, 15);
      expect(date.formattedDate, '15/6/2020');
    });
  });

  group('DoubleExtension', () {
    test('asCurrency formats correctly', () {
      expect(9.99.asCurrency, '\$9.99');
      expect(0.0.asCurrency, '\$0.00');
    });
  });
}

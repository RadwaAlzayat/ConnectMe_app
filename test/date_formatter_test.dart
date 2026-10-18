import 'package:connectme_app/core/utils/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 18, 12);

  String format(Duration age) =>
      DateFormatter.timeAgo(now.subtract(age), now: now);

  group('DateFormatter.timeAgo', () {
    test('shows "Just now" under a minute', () {
      expect(format(const Duration(seconds: 20)), 'Just now');
    });

    test('shows minutes, hours and days', () {
      expect(format(const Duration(minutes: 5)), '5 min ago');
      expect(format(const Duration(hours: 3)), '3 h ago');
      expect(format(const Duration(days: 2)), '2 d ago');
    });

    test('shows the date after a week', () {
      expect(
        DateFormatter.timeAgo(DateTime(2026, 10, 1), now: now),
        '1/10/2026',
      );
    });
  });
}

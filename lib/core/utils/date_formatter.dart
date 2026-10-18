/// Turns a date into short text for the feed ("5 min ago").
class DateFormatter {
  DateFormatter._();

  /// [now] can be passed in tests so the result does not depend on the clock.
  static String timeAgo(DateTime dateTime, {DateTime? now}) {
    final difference = (now ?? DateTime.now()).difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} h ago';
    if (difference.inDays < 7) return '${difference.inDays} d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

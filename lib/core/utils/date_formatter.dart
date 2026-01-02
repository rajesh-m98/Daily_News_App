import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  /// Format ISO 8601 date to readable format
  /// Example: "2024-01-15T10:30:00Z" -> "Jan 15, 2024"
  static String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return 'Unknown date';
    }
  }

  /// Format ISO 8601 date to time ago format
  /// Example: "2 hours ago", "3 days ago"
  static String timeAgo(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        final days = difference.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Format ISO 8601 date to time format
  /// Example: "10:30 AM"
  static String formatTime(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown time';
    }
  }

  /// Format ISO 8601 date to full date and time
  /// Example: "Jan 15, 2024 at 10:30 AM"
  static String formatDateTime(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(dateTime);
    } catch (e) {
      return 'Unknown date';
    }
  }
}

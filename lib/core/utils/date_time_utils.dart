/// Safe date formatting and time helpers for mood logs and journals.
abstract final class DateTimeUtils {
  static String formatShortDate(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatAmPmTime(DateTime dateTime) {
    int hour = dateTime.hour;
    final isPm = hour >= 12;
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = isPm ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static const List<String> _monthNames = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  static const List<String> _fullMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String formatJournalHeaderDate(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final isYesterday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.subtract(const Duration(days: 1)).day;

    final monthStr = _monthNames[dt.month - 1];
    final dateBase = '$monthStr ${dt.day}, ${dt.year}';

    if (isToday) {
      return '$dateBase â€¢ TODAY';
    } else if (isYesterday) {
      return '$dateBase â€¢ YESTERDAY';
    }
    return dateBase;
  }

  static String formatRelativeDate(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final isYesterday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.subtract(const Duration(days: 1)).day;

    if (isToday) {
      return 'TODAY â€¢ ${formatAmPmTime(dt)}';
    } else if (isYesterday) {
      return 'YESTERDAY';
    } else {
      final monthStr = _monthNames[dt.month - 1];
      return '$monthStr ${dt.day}, ${dt.year}';
    }
  }

  static String formatFullDateTime(DateTime dt) {
    final monthStr = _fullMonthNames[dt.month - 1];
    return '$monthStr ${dt.day}, ${dt.year} at ${formatAmPmTime(dt)}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}


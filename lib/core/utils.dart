import 'package:intl/intl.dart';
import 'constants.dart';

class AppUtils {
  // Format currency in Mongolian Tugrik
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.0', 'en_US');
    return '${formatter.format(amount)}${AppConstants.currency}';
  }
  
  // Format time ago in Mongolian
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${AppConstants.minutesAgo}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${AppConstants.hoursAgo}';
    } else {
      return '${difference.inDays} ${AppConstants.daysAgo}';
    }
  }
  
  // Format time (HH:mm)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  // Format date (yyyy-MM-dd)
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
  
  // Format date with Mongolian month names
  static String formatDateMongolian(DateTime dateTime) {
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year;
    
    final monthNames = [
      '1-р сар', '2-р сар', '3-р сар', '4-р сар',
      '5-р сар', '6-р сар', '7-р сар', '8-р сар',
      '9-р сар', '10-р сар', '11-р сар', '12-р сар'
    ];
    
    return '$year оны ${monthNames[month - 1]} $day';
  }
  
  // Format distance in km
  static String formatDistance(double distanceInKm) {
    return '${distanceInKm.toStringAsFixed(1)} км';
  }
  
  // Format phone number with country code
  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+976')) {
      return phone;
    }
    return '+976$phone';
  }
  
  // Validate phone number
  static bool isValidPhoneNumber(String phone) {
    // Remove spaces and dashes
    final cleaned = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if it's 8 digits (Mongolian mobile number)
    if (cleaned.length == 8) {
      return RegExp(r'^[6-9]\d{7}$').hasMatch(cleaned);
    }
    
    // Check if it's with country code
    if (cleaned.startsWith('+976') && cleaned.length == 12) {
      return RegExp(r'^\+976[6-9]\d{7}$').hasMatch(cleaned);
    }
    
    return false;
  }
}

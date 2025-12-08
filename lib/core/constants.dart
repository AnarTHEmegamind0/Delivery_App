// Core Constants
class AppConstants {
  // API Endpoints (Mock for now)
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '/auth/login';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String notificationsEndpoint = '/notifications';
  static const String ordersEndpoint = '/orders';
  static const String driverProfileEndpoint = '/driver/profile';
  static const String earningsEndpoint = '/driver/earnings';
  static const String ratingsEndpoint = '/driver/ratings';
  
  // App Strings (Mongolian)
  static const String appName = 'Super Delivery';
  static const String driverApp = 'Driver';
  static const String customerApp = 'Customer App';
  
  // Login
  static const String phoneNumberHint = 'Утасны дугаар';
  static const String sendCode = 'Код илгээх';
  static const String enterCode = 'Бид танд 4 оронтой код илгээх болно';
  
  // Home
  static const String todayEarnings = 'Өнөөдрийн орлого';
  static const String online = 'ONLINE';
  static const String offline = 'OFFLINE';
  static const String waiting = 'Хүлээх байна';
  static const String inProgress = 'Явж байна';
  static const String completed = 'Дууссан';
  
  // Navigation
  static const String myDelivery = 'Миний хүргэлт';
  static const String orders = 'Явж байна';
  static const String notifications = 'Мэдэгдэл';
  static const String settings = 'Тохиргоо';
  
  // Notifications
  static const String newOrder = 'Шинэ захиалга';
  static const String customerNeed = 'Хэрэглэгчийн дуудлага';
  static const String payment = 'Мөнгө шилжүүлэх';
  static const String systemMessage = 'Системийн мэдэгдэл';
  static const String orderRequest = 'Захиалга цуцлагдсан';
  
  // Profile
  static const String myRating = 'Миний үнэлгээ';
  static const String withdraw = 'Мөнгө татах';
  static const String darkMode = 'Харанхуй горим';
  static const String help = 'Тусламж';
  static const String vehicleNumber = 'Машины дугаар';
  
  // Rating
  static const String reviews = 'үнэлгээ';
  static const String deliveries = 'хүргэлт';
  static const String ratingBreakdown = 'Үнэлгээний задаргаа';
  static const String recentReviews = 'Сүүлийн үнэлгээнүүд';
  static const String thisMonth = 'Өссөн +0.2 энэ сард';
  
  // Currency
  static const String currency = '₮';
  
  // Time formats
  static const String minutesAgo = 'минутын өмнө';
  static const String hoursAgo = 'цагийн өмнө';
  static const String daysAgo = 'өдрийн өмнө';
}

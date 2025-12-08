import '../models/notification_model.dart';

class NotificationRepository {
  // Mock data for now
  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.newOrder,
        title: 'Шинэ захиалга',
        description: 'Баянзүрх дүүрэг, 15-р хороо - 35,000₮',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.customerNeed,
        title: 'Хэрэглэгчийн дуудлага',
        description: 'Б. Батсайхан дуудлага байна',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.payment,
        title: 'Мөнгө шилжүүлэх',
        description: '450,000₮ таны карт руу шилжлээ',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.system,
        title: 'Системийн мэдэгдэл',
        description: 'Өнөөдөр 18:00-20:00 цагт захиалга ихсэх төлөвтэй байна',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.orderRequest,
        title: 'Захиалга цуцлагдсан',
        description: 'Захиалга #12345 хэрэглэгч цуцалсан',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
    ];
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In real app, would make API call
  }

  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // In real app, would make API call
  }

  Future<int> getUnreadCount() async {
    final notifications = await fetchNotifications();
    return notifications.where((n) => !n.isRead).length;
  }
}

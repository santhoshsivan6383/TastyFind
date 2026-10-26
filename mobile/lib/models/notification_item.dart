class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String type; // 'review_helpful' | 'offer' | 'price_update' | 'new_restaurant'
  final String timeAgo;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timeAgo,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      timeAgo: json['time_ago'] as String? ?? 'Just now',
      isRead: json['is_read'] as bool? ?? false,
    );
  }
}

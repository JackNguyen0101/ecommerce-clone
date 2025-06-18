class AppNotification {
  String? id;
  final String message;
  final String orderId;
  final String status;
  final List<dynamic> images;
  final DateTime date;
  bool read;

  AppNotification({
    this.id,
    required this.message,
    required this.orderId,
    required this.status,
    required this.images,
    required this.date,
    required this.read,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['_id'],
      message: map['message']?.toString() ?? '',
      orderId: map['orderId']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      images: map['images'] ?? [],
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      read: map['read'] ?? false,
    );
  }
}

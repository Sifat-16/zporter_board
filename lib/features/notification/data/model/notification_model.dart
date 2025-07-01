/// Represents the data model for a notification.
///
/// This class defines the structure of a notification object, including its
/// content, metadata, and state (e.g., whether it has been read). It includes
/// methods for converting to and from a map, which is necessary for storing
/// the notification data in the local Sembast database.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime sentTime;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.sentTime,
    this.isRead = false,
  });

  /// Creates a [NotificationModel] from a map (e.g., from Sembast).
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      category: map['category'] as String,
      sentTime: DateTime.parse(map['sentTime'] as String),
      isRead: map['isRead'] as bool,
    );
  }

  /// Converts the [NotificationModel] to a map for local storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'sentTime': sentTime.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Creates a copy of this notification with updated fields.
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? sentTime,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      sentTime: sentTime ?? this.sentTime,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Represents the data model for a notification.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime sentTime;
  final bool isRead;
  final String? coverImageUrl; // New field for the teaser image
  final List<String>? mediaUrls; // New field for the full media gallery

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.sentTime,
    this.isRead = false,
    this.coverImageUrl,
    this.mediaUrls,
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
      coverImageUrl: map['coverImageUrl'] as String?,
      mediaUrls: (map['mediaUrls'] as List<dynamic>?)?.cast<String>(),
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
      'coverImageUrl': coverImageUrl,
      'mediaUrls': mediaUrls,
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
    String? coverImageUrl,
    List<String>? mediaUrls,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      sentTime: sentTime ?? this.sentTime,
      isRead: isRead ?? this.isRead,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }
}

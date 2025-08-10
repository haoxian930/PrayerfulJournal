enum PrayerRequestStatus {
  pending,
  inProgress,
  answered,
}

enum PrayerCategory {
  personal,
  family,
  ministry,
  global,
  health,
  work,
  relationships,
  spiritual,
}

class PrayerRequest { // Link to answered prayer story

  PrayerRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.answeredAt,
    this.answeredStoryId,
  });

  factory PrayerRequest.fromMap(Map<String, dynamic> map) {
    return PrayerRequest(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: PrayerCategory.values[map['category']],
      status: PrayerRequestStatus.values[map['status']],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      answeredAt: map['answered_at'] != null ? DateTime.parse(map['answered_at']) : null,
      answeredStoryId: map['answered_story_id'],
    );
  }
  final String id;
  final String title;
  final String description;
  final PrayerCategory category;
  final PrayerRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? answeredAt;
  final String? answeredStoryId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'status': status.index,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'answered_at': answeredAt?.toIso8601String(),
      'answered_story_id': answeredStoryId,
    };
  }

  PrayerRequest copyWith({
    String? id,
    String? title,
    String? description,
    PrayerCategory? category,
    PrayerRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? answeredAt,
    String? answeredStoryId,
  }) {
    return PrayerRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      answeredAt: answeredAt ?? this.answeredAt,
      answeredStoryId: answeredStoryId ?? this.answeredStoryId,
    );
  }

  String get categoryDisplayName {
    switch (category) {
      case PrayerCategory.personal:
        return 'Personal';
      case PrayerCategory.family:
        return 'Family';
      case PrayerCategory.ministry:
        return 'Ministry';
      case PrayerCategory.global:
        return 'Global';
      case PrayerCategory.health:
        return 'Health';
      case PrayerCategory.work:
        return 'Work';
      case PrayerCategory.relationships:
        return 'Relationships';
      case PrayerCategory.spiritual:
        return 'Spiritual';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case PrayerRequestStatus.pending:
        return 'Pending';
      case PrayerRequestStatus.inProgress:
        return 'In Progress';
      case PrayerRequestStatus.answered:
        return 'Answered';
    }
  }
}

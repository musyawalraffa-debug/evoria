import 'dart:convert';

/// Represents a single romantic memory in the EVORIA sanctuary.
class MemoryItem {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String note;
  final String mood; // 'Bahagia', 'Hangat', 'Haru', 'Rindu', 'Romantis'
  final String? imagePath; // Local file path or asset/mock identifier
  final bool isFavorite;
  final String? partnerReaction; // 'love', 'warmth', 'hugs', 'miss_you'
  final String? partnerReactionNote;
  final DateTime createdAt;

  const MemoryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.note,
    required this.mood,
    this.imagePath,
    this.isFavorite = false,
    this.partnerReaction,
    this.partnerReactionNote,
    required this.createdAt,
  });

  MemoryItem copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? location,
    String? note,
    String? mood,
    String? imagePath,
    bool? isFavorite,
    String? partnerReaction,
    String? partnerReactionNote,
    DateTime? createdAt,
  }) {
    return MemoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      location: location ?? this.location,
      note: note ?? this.note,
      mood: mood ?? this.mood,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      partnerReaction: partnerReaction ?? this.partnerReaction,
      partnerReactionNote: partnerReactionNote ?? this.partnerReactionNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'location': location,
      'note': note,
      'mood': mood,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
      'partnerReaction': partnerReaction,
      'partnerReactionNote': partnerReactionNote,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MemoryItem.fromMap(Map<String, dynamic> map) {
    return MemoryItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: DateTime.parse(map['date']),
      location: map['location'] ?? '',
      note: map['note'] ?? '',
      mood: map['mood'] ?? 'Hangat',
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] ?? false,
      partnerReaction: map['partnerReaction'],
      partnerReactionNote: map['partnerReactionNote'],
      createdAt: DateTime.parse(map['createdAt'] ?? map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MemoryItem.fromJson(String source) =>
      MemoryItem.fromMap(json.decode(source));
}

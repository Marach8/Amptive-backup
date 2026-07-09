import 'package:intl/intl.dart';

enum RecentSearchType { user, show, event, hashtag }

/// One saved recent-search entry — an entity the user opened from search
/// results (creator, show, event, or hashtag).
class RecentSearchEntry {
  const RecentSearchEntry({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.isPaid = false,
    this.status,
    this.scheduledFor,
  });

  factory RecentSearchEntry.fromJson(Map<String, dynamic> json) {
    return RecentSearchEntry(
      type: RecentSearchType.values.firstWhere(
        (RecentSearchType type) => type.name == json['type'],
        orElse: () => RecentSearchType.show,
      ),
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      imageUrl: json['image_url'],
      isPaid: json['is_paid'] ?? false,
      status: json['status'],
      scheduledFor: json['scheduled_for'],
    );
  }

  final RecentSearchType type;
  final String id, title;

  /// Username for user entries, category for shows/events.
  final String? subtitle;
  final String? imageUrl;
  final bool isPaid;

  /// Raw backend status: 'live' | 'ended' | 'scheduled' | ...
  final String? status;

  /// ISO-8601 start time for scheduled shows/events.
  final String? scheduledFor;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type.name,
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'image_url': imageUrl,
        'is_paid': isPaid,
        'status': status,
        'scheduled_for': scheduledFor,
      };

  /// The type label shown first in the subtitle: 'Show', 'Event', 'Hashtag',
  /// or the username for creators.
  String get typeLabel => switch (type) {
        RecentSearchType.show => 'Show',
        RecentSearchType.event => 'Event',
        RecentSearchType.hashtag => 'Hashtag',
        RecentSearchType.user => subtitle ?? '',
      };

  /// 'LIVE', 'Ended', 'MONDAY at 20:00' (within a week) or
  /// '27 SEP 2024 at 19:00' — null when there's nothing to show.
  String? get statusLabel {
    if (type == RecentSearchType.user || type == RecentSearchType.hashtag) {
      return null;
    }
    final String normalized = status?.toLowerCase() ?? '';
    if (normalized == 'live') return 'LIVE';
    if (normalized == 'ended' || normalized == 'completed') return 'Ended';

    final DateTime? date = DateTime.tryParse(scheduledFor ?? '')?.toLocal();
    if (date == null) return null;
    final String time = DateFormat.Hm().format(date);
    final DateTime now = DateTime.now();
    if (date.isAfter(now) && date.difference(now).inDays < 7) {
      return '${DateFormat.EEEE().format(date).toUpperCase()} at $time';
    }
    return '${DateFormat('d MMM yyyy').format(date).toUpperCase()} at $time';
  }
}

/// Data Transfer Object representing user profile and preference state.
class UserProfileDto {
  final String id;
  final String language;
  final bool isAge18Plus;
  final bool consentGiven;
  final DateTime createdAt;

  const UserProfileDto({
    required this.id,
    required this.language,
    required this.isAge18Plus,
    required this.consentGiven,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'isAge18Plus': isAge18Plus,
      'consentGiven': consentGiven,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      isAge18Plus: json['isAge18Plus'] as bool? ?? false,
      consentGiven: json['consentGiven'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}


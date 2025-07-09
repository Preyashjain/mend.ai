// lib/models/session_model.dart
class SessionModel {
  final String id;
  final String userId;
  final String partnerId;
  final DateTime timestamp;
  final String status; // 'active', 'completed', 'paused'
  final String? currentSpeaker; // 'user' or 'partner'
  final List<String> aiPrompts;
  final List<String> interruptions;
  final int? userScore;
  final int? partnerScore;
  final String? reflection;

  SessionModel({
    required this.id,
    required this.userId,
    required this.partnerId,
    required this.timestamp,
    this.status = 'active',
    this.currentSpeaker,
    this.aiPrompts = const [],
    this.interruptions = const [],
    this.userScore,
    this.partnerScore,
    this.reflection,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['\$id'] ?? map['id'],
      userId: map['userId'] ?? '',
      partnerId: map['partnerId'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'] ?? 'active',
      currentSpeaker: map['currentSpeaker'],
      aiPrompts: List<String>.from(map['aiPrompts'] ?? []),
      interruptions: List<String>.from(map['interruptions'] ?? []),
      userScore: map['userScore'],
      partnerScore: map['partnerScore'],
      reflection: map['reflection'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'partnerId': partnerId,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'currentSpeaker': currentSpeaker,
      'aiPrompts': aiPrompts,
      'interruptions': interruptions,
      'userScore': userScore,
      'partnerScore': partnerScore,
      'reflection': reflection,
    };
  }

  SessionModel copyWith({
    String? id,
    String? userId,
    String? partnerId,
    DateTime? timestamp,
    String? status,
    String? currentSpeaker,
    List<String>? aiPrompts,
    List<String>? interruptions,
    int? userScore,
    int? partnerScore,
    String? reflection,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      partnerId: partnerId ?? this.partnerId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      currentSpeaker: currentSpeaker ?? this.currentSpeaker,
      aiPrompts: aiPrompts ?? this.aiPrompts,
      interruptions: interruptions ?? this.interruptions,
      userScore: userScore ?? this.userScore,
      partnerScore: partnerScore ?? this.partnerScore,
      reflection: reflection ?? this.reflection,
    );
  }
}
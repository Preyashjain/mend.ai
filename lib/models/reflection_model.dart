// lib/models/reflection_model.dart
class ReflectionModel {
  final String id;
  final String sessionId;
  final String userId;
  final String partnerId;
  final String userReflection;
  final String partnerReflection;
  final List<String> sharedGratitude;
  final List<String> bondingActivities;
  final DateTime timestamp;
  final bool isCompleted;

  ReflectionModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.partnerId,
    required this.userReflection,
    required this.partnerReflection,
    this.sharedGratitude = const [],
    this.bondingActivities = const [],
    required this.timestamp,
    this.isCompleted = false,
  });

  factory ReflectionModel.fromMap(Map<String, dynamic> map) {
    return ReflectionModel(
      id: map['\$id'] ?? map['id'],
      sessionId: map['sessionId'] ?? '',
      userId: map['userId'] ?? '',
      partnerId: map['partnerId'] ?? '',
      userReflection: map['userReflection'] ?? '',
      partnerReflection: map['partnerReflection'] ?? '',
      sharedGratitude: List<String>.from(map['sharedGratitude'] ?? []),
      bondingActivities: List<String>.from(map['bondingActivities'] ?? []),
      timestamp: DateTime.parse(map['timestamp']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'partnerId': partnerId,
      'userReflection': userReflection,
      'partnerReflection': partnerReflection,
      'sharedGratitude': sharedGratitude,
      'bondingActivities': bondingActivities,
      'timestamp': timestamp.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  ReflectionModel copyWith({
    String? id,
    String? sessionId,
    String? userId,
    String? partnerId,
    String? userReflection,
    String? partnerReflection,
    List<String>? sharedGratitude,
    List<String>? bondingActivities,
    DateTime? timestamp,
    bool? isCompleted,
  }) {
    return ReflectionModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      partnerId: partnerId ?? this.partnerId,
      userReflection: userReflection ?? this.userReflection,
      partnerReflection: partnerReflection ?? this.partnerReflection,
      sharedGratitude: sharedGratitude ?? this.sharedGratitude,
      bondingActivities: bondingActivities ?? this.bondingActivities,
      timestamp: timestamp ?? this.timestamp,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
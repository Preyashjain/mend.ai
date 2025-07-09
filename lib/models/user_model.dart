// lib/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final String gender; // 'male', 'female', 'other'
  final String? partnerId;
  final String? partnerName;
  final String? partnerGender;
  final List<String> relationshipGoals;
  final List<String> currentChallenges;
  final String? partnerInviteCode;
  final bool isOnboarded;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    this.partnerId,
    this.partnerName,
    this.partnerGender,
    this.relationshipGoals = const [],
    this.currentChallenges = const [],
    this.partnerInviteCode,
    this.isOnboarded = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] ?? map['id'],
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      partnerId: map['partnerId'],
      partnerName: map['partnerName'],
      partnerGender: map['partnerGender'],
      relationshipGoals: List<String>.from(map['relationshipGoals'] ?? []),
      currentChallenges: List<String>.from(map['currentChallenges'] ?? []),
      partnerInviteCode: map['partnerInviteCode'],
      isOnboarded: map['isOnboarded'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'gender': gender,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'partnerGender': partnerGender,
      'relationshipGoals': relationshipGoals,
      'currentChallenges': currentChallenges,
      'partnerInviteCode': partnerInviteCode,
      'isOnboarded': isOnboarded,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? gender,
    String? partnerId,
    String? partnerName,
    String? partnerGender,
    List<String>? relationshipGoals,
    List<String>? currentChallenges,
    String? partnerInviteCode,
    bool? isOnboarded,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      partnerGender: partnerGender ?? this.partnerGender,
      relationshipGoals: relationshipGoals ?? this.relationshipGoals,
      currentChallenges: currentChallenges ?? this.currentChallenges,
      partnerInviteCode: partnerInviteCode ?? this.partnerInviteCode,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }
}

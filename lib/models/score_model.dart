// lib/models/score_model.dart
class ScoreModel {
  final String id;
  final String sessionId;
  final String userId;
  final String partnerId;
  final Map<String, int> userScores; // empathy, listening, reception, clarity, respect, responsiveness, openMindedness
  final Map<String, int> partnerScores;
  final int userTotalScore;
  final int partnerTotalScore;
  final List<String> userStrengths;
  final List<String> userSuggestions;
  final List<String> partnerStrengths;
  final List<String> partnerSuggestions;
  final DateTime timestamp;

  ScoreModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.partnerId,
    required this.userScores,
    required this.partnerScores,
    required this.userTotalScore,
    required this.partnerTotalScore,
    required this.userStrengths,
    required this.userSuggestions,
    required this.partnerStrengths,
    required this.partnerSuggestions,
    required this.timestamp,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['\$id'] ?? map['id'],
      sessionId: map['sessionId'] ?? '',
      userId: map['userId'] ?? '',
      partnerId: map['partnerId'] ?? '',
      userScores: Map<String, int>.from(map['userScores'] ?? {}),
      partnerScores: Map<String, int>.from(map['partnerScores'] ?? {}),
      userTotalScore: map['userTotalScore'] ?? 0,
      partnerTotalScore: map['partnerTotalScore'] ?? 0,
      userStrengths: List<String>.from(map['userStrengths'] ?? []),
      userSuggestions: List<String>.from(map['userSuggestions'] ?? []),
      partnerStrengths: List<String>.from(map['partnerStrengths'] ?? []),
      partnerSuggestions: List<String>.from(map['partnerSuggestions'] ?? []),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'partnerId': partnerId,
      'userScores': userScores,
      'partnerScores': partnerScores,
      'userTotalScore': userTotalScore,
      'partnerTotalScore': partnerTotalScore,
      'userStrengths': userStrengths,
      'userSuggestions': userSuggestions,
      'partnerStrengths': partnerStrengths,
      'partnerSuggestions': partnerSuggestions,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Get score for a specific criteria
  int getUserScore(String criteria) {
    return userScores[criteria] ?? 0;
  }

  int getPartnerScore(String criteria) {
    return partnerScores[criteria] ?? 0;
  }

  // Get average score
  double getUserAverageScore() {
    if (userScores.isEmpty) return 0;
    return userScores.values.reduce((a, b) => a + b) / userScores.length;
  }

  double getPartnerAverageScore() {
    if (partnerScores.isEmpty) return 0;
    return partnerScores.values.reduce((a, b) => a + b) / partnerScores.length;
  }
}
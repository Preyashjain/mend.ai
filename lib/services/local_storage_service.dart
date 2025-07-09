import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  // In-memory storage for demo purposes
  final Map<String, dynamic> _users = {};
  final Map<String, dynamic> _sessions = {};
  final Map<String, dynamic> _reflections = {};
  final Map<String, dynamic> _scores = {};

  // User operations
  Future<String> createUser({
    required String name,
    required String gender,
    List<String>? relationshipGoals,
    List<String>? currentChallenges,
  }) async {
    final userId = const Uuid().v4();
    final sessionCode = const Uuid().v4();
    
    _users[userId] = {
      'id': userId,
      'name': name,
      'gender': gender,
      'sessionCode': sessionCode,
      'partnerJoined': false,
      'relationshipGoals': relationshipGoals ?? [],
      'currentChallenges': currentChallenges ?? [],
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    if (kDebugMode) {
      print('User created: $userId, Session Code: $sessionCode');
    }
    
    return userId;
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    return _users[userId];
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return _users.values.cast<Map<String, dynamic>>().toList();
  }

  // Session operations
  Future<String> createSession(String userId, String partnerId) async {
    final sessionId = const Uuid().v4();
    
    _sessions[sessionId] = {
      'id': sessionId,
      'userId': userId,
      'partnerId': partnerId,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (kDebugMode) {
      print('Session created: $sessionId');
    }
    
    return sessionId;
  }

  Future<Map<String, dynamic>?> getSession(String sessionId) async {
    return _sessions[sessionId];
  }

  // Reflection operations
  Future<String> createReflection(String sessionId, String content) async {
    final reflectionId = const Uuid().v4();
    
    _reflections[reflectionId] = {
      'id': reflectionId,
      'sessionId': sessionId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (kDebugMode) {
      print('Reflection created: $reflectionId');
    }
    
    return reflectionId;
  }

  Future<Map<String, dynamic>?> getReflection(String sessionId) async {
    for (final reflection in _reflections.values) {
      if (reflection['sessionId'] == sessionId) {
        return reflection;
      }
    }
    return null;
  }

  // Score operations
  Future<String> createScore(String sessionId, int score) async {
    final scoreId = const Uuid().v4();
    
    _scores[scoreId] = {
      'id': scoreId,
      'sessionId': sessionId,
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    if (kDebugMode) {
      print('Score created: $scoreId, Score: $score');
    }
    
    return scoreId;
  }

  Future<Map<String, dynamic>?> getScore(String sessionId) async {
    for (final score in _scores.values) {
      if (score['sessionId'] == sessionId) {
        return score;
      }
    }
    return null;
  }

  // Clear all data (for testing)
  void clearAll() {
    _users.clear();
    _sessions.clear();
    _reflections.clear();
    _scores.clear();
  }
}

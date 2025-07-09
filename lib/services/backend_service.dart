import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/score_model.dart';
import '../models/reflection_model.dart';
import 'service_config.dart';
import 'appwrite_service.dart';
import 'firebase_service.dart';

class BackendService {
  static final AppwriteService _appwriteService = AppwriteService();
  static final FirebaseService _firebaseService = FirebaseService();

  // -------------------- AUTH --------------------

  static Future<dynamic> signIn(String email, String password) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.signIn(email, password);
      case BackendType.firebase:
        return await _firebaseService.signIn(email, password);
    }
  }

  static Future<dynamic> signUp(String email, String password, String name) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.signUp(email, password, name);
      case BackendType.firebase:
        return await _firebaseService.signUp(email, password, name);
    }
  }

  static Future<void> logout() async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        await _appwriteService.logout();
        break;
      case BackendType.firebase:
        await _firebaseService.logout();
        break;
    }
  }

  static dynamic getCurrentUser() {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return _appwriteService.getCurrentUser();
      case BackendType.firebase:
        return _firebaseService.getCurrentUser();
    }
  }

  static Stream<dynamic> get authStateChanges {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return _appwriteService.authStateChanges;
      case BackendType.firebase:
        return _firebaseService.authStateChanges;
    }
  }

  // -------------------- USER --------------------

  static Future<UserModel> createUser({
    required String name,
    required String email,
    required String gender,
    List<String> relationshipGoals = const [],
    List<String> currentChallenges = const [],
  }) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.createUser(
          name: name,
          email: email,
          gender: gender,
          relationshipGoals: relationshipGoals,
          currentChallenges: currentChallenges,
        );
      case BackendType.firebase:
        return await _firebaseService.createUser(
          name: name,
          email: email,
          gender: gender,
          relationshipGoals: relationshipGoals,
          currentChallenges: currentChallenges,
        );
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.getUserById(userId);
      case BackendType.firebase:
        return await _firebaseService.getUserById(userId);
    }
  }

  static Future<UserModel?> getUserByInviteCode(String inviteCode) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.getUserByInviteCode(inviteCode);
      case BackendType.firebase:
        return await _firebaseService.getUserByInviteCode(inviteCode);
    }
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        await _appwriteService.updateUser(userId, updates);
        break;
      case BackendType.firebase:
        await _firebaseService.updateUser(userId, updates);
        break;
    }
  }

  static Future<void> connectPartners(
    String user1Id,
    String user2Id,
    String user1Name,
    String user2Name,
    String user1Gender,
    String user2Gender,
  ) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        await _appwriteService.connectPartners(
          user1Id,
          user2Id,
          user1Name,
          user2Name,
          user1Gender,
          user2Gender,
        );
        break;
      case BackendType.firebase:
        await _firebaseService.connectPartners(
          user1Id,
          user2Id,
          user1Name,
          user2Name,
          user1Gender,
          user2Gender,
        );
        break;
    }
  }

  // -------------------- SESSION --------------------

  static Future<SessionModel> createSession({
    required String userId,
    required String partnerId,
  }) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.createSession(
          userId: userId,
          partnerId: partnerId,
        );
      case BackendType.firebase:
        return await _firebaseService.createSession(
          userId: userId,
          partnerId: partnerId,
        );
    }
  }

  static Future<List<SessionModel>> getUserSessions(String userId) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.getUserSessions(userId);
      case BackendType.firebase:
        return await _firebaseService.getUserSessions(userId);
    }
  }

  static Future<void> updateSession(String sessionId, Map<String, dynamic> updates) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        await _appwriteService.updateSession(sessionId, updates);
        break;
      case BackendType.firebase:
        await _firebaseService.updateSession(sessionId, updates);
        break;
    }
  }

  // -------------------- SCORE --------------------

  static Future<ScoreModel> createScore({
    required String sessionId,
    required String userId,
    required String partnerId,
    required Map<String, int> userScores,
    required Map<String, int> partnerScores,
    required List<String> userStrengths,
    required List<String> userSuggestions,
    required List<String> partnerStrengths,
    required List<String> partnerSuggestions,
  }) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.createScore(
          sessionId: sessionId,
          userId: userId,
          partnerId: partnerId,
          userScores: userScores,
          partnerScores: partnerScores,
          userStrengths: userStrengths,
          userSuggestions: userSuggestions,
          partnerStrengths: partnerStrengths,
          partnerSuggestions: partnerSuggestions,
        );
      case BackendType.firebase:
        return await _firebaseService.createScore(
          sessionId: sessionId,
          userId: userId,
          partnerId: partnerId,
          userScores: userScores,
          partnerScores: partnerScores,
          userStrengths: userStrengths,
          userSuggestions: userSuggestions,
          partnerStrengths: partnerStrengths,
          partnerSuggestions: partnerSuggestions,
        );
    }
  }

  static Future<List<ScoreModel>> getUserScores(String userId) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.getUserScores(userId);
      case BackendType.firebase:
        return await _firebaseService.getUserScores(userId);
    }
  }

  // -------------------- REFLECTION --------------------

  static Future<ReflectionModel> createReflection({
    required String sessionId,
    required String userId,
    required String partnerId,
    required String userReflection,
    required String partnerReflection,
    List<String> sharedGratitude = const [],
    List<String> bondingActivities = const [],
  }) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.createReflection(
          sessionId: sessionId,
          userId: userId,
          partnerId: partnerId,
          userReflection: userReflection,
          partnerReflection: partnerReflection,
          sharedGratitude: sharedGratitude,
          bondingActivities: bondingActivities,
        );
      case BackendType.firebase:
        return await _firebaseService.createReflection(
          sessionId: sessionId,
          userId: userId,
          partnerId: partnerId,
          userReflection: userReflection,
          partnerReflection: partnerReflection,
          sharedGratitude: sharedGratitude,
          bondingActivities: bondingActivities,
        );
    }
  }

  static Future<List<ReflectionModel>> getUserReflections(String userId) async {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return await _appwriteService.getUserReflections(userId);
      case BackendType.firebase:
        return await _firebaseService.getUserReflections(userId);
    }
  }

  // -------------------- REALTIME SUBSCRIPTION --------------------

  static Stream<dynamic> subscribeToSessions(String userId) {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return _appwriteService.subscribeToSessions(userId);
      case BackendType.firebase:
        return _firebaseService.subscribeToSessions(userId);
    }
  }

  static Stream<dynamic> subscribeToScores(String userId) {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return _appwriteService.subscribeToScores(userId);
      case BackendType.firebase:
        return _firebaseService.subscribeToScores(userId);
    }
  }

  static Stream<dynamic> subscribeToReflections(String userId) {
    switch (ServiceConfig.backendType) {
      case BackendType.appwrite:
        return _appwriteService.subscribeToReflections(userId);
      case BackendType.firebase:
        return _firebaseService.subscribeToReflections(userId);
    }
  }
} 
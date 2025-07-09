import 'dart:io';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/score_model.dart';
import '../models/reflection_model.dart';

class AppwriteService {
  static const String projectId = '6867d1640005887ddf21';
  static const String databaseId = '6867d6cb0013abfb7a2d';
  static const String userCollectionId = '6867d73b003a66442f24';
  static const String sessionCollectionId = '6867d79900295565e0e3';
  static const String reflectionCollectionId = '6867d7a90020a09bf4b0';
  static const String scoreCollectionId = '6867d7bf0030a835d632';
  static const String bucketId = 'audio_bucket';

  final Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject(projectId);

  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;

  AppwriteService() {
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
  }

  // -------------------- AUTH --------------------

  Future<models.Session> signIn(String email, String password) async {
    return await account.createEmailPasswordSession(email: email, password: password);
  }

  Future<models.User> signUp(String email, String password, String name) async {
    final user = await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    return user;
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<models.User> getUser() async {
    return await account.get();
  }

  models.User? getCurrentUser() {
    // Appwrite doesn't have a synchronous getCurrentUser method
    // We'll return null and handle this in the calling code
    return null;
  }

  Stream<models.User?> get authStateChanges {
    // Appwrite doesn't have built-in auth state changes like Firebase
    // We'll create a simple stream that emits the current user
    return Stream.periodic(const Duration(seconds: 1), (_) async {
      try {
        return await account.get();
      } catch (e) {
        return null;
      }
    }).asyncMap((future) => future);
  }

  // -------------------- USER --------------------

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String gender,
    List<String> relationshipGoals = const [],
    List<String> currentChallenges = const [],
  }) async {
    final userId = const Uuid().v4();
    final inviteCode = _generateInviteCode();
    
    final userData = {
      'name': name,
      'email': email,
      'gender': gender,
      'relationshipGoals': relationshipGoals,
      'currentChallenges': currentChallenges,
      'partnerInviteCode': inviteCode,
      'isOnboarded': true,
      'createdAt': DateTime.now().toIso8601String(),
    };

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: userCollectionId,
      documentId: userId,
      data: userData,
    );

    return UserModel(
      id: userId,
      email: email,
      name: name,
      gender: gender,
      relationshipGoals: relationshipGoals,
      currentChallenges: currentChallenges,
      partnerInviteCode: inviteCode,
      isOnboarded: true,
    );
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final document = await databases.getDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: userId,
      );
      return UserModel.fromMap(document.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserByInviteCode(String inviteCode) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: userCollectionId,
        queries: [Query.equal('partnerInviteCode', inviteCode)],
      );
      
      if (result.documents.isNotEmpty) {
        return UserModel.fromMap(result.documents.first.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: userCollectionId,
      documentId: userId,
      data: updates,
    );
  }

  Future<void> connectPartners(String user1Id, String user2Id, String user1Name, String user2Name, String user1Gender, String user2Gender) async {
    // Update user 1 with partner info
    await updateUser(user1Id, {
      'partnerId': user2Id,
      'partnerName': user2Name,
      'partnerGender': user2Gender,
    });

    // Update user 2 with partner info
    await updateUser(user2Id, {
      'partnerId': user1Id,
      'partnerName': user1Name,
      'partnerGender': user1Gender,
    });
  }

  // -------------------- SESSION --------------------

  Future<SessionModel> createSession({
    required String userId,
    required String partnerId,
  }) async {
    final sessionId = const Uuid().v4();
    final sessionData = {
      'userId': userId,
      'partnerId': partnerId,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'active',
      'aiPrompts': [],
      'interruptions': [],
    };

    final document = await databases.createDocument(
      databaseId: databaseId,
      collectionId: sessionCollectionId,
      documentId: sessionId,
      data: sessionData,
    );

    return SessionModel.fromMap(document.data);
  }

  Future<List<SessionModel>> getUserSessions(String userId) async {
    try {
      final result = await databases.listDocuments(
      databaseId: databaseId,
        collectionId: sessionCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('timestamp'),
        ],
      );

      return result.documents.map((doc) => SessionModel.fromMap(doc.data)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateSession(String sessionId, Map<String, dynamic> updates) async {
    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: sessionCollectionId,
      documentId: sessionId,
      data: updates,
    );
  }

  // -------------------- SCORE --------------------

  Future<ScoreModel> createScore({
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
    final scoreId = const Uuid().v4();
    final userTotalScore = userScores.values.reduce((a, b) => a + b);
    final partnerTotalScore = partnerScores.values.reduce((a, b) => a + b);

    final scoreData = {
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
      'timestamp': DateTime.now().toIso8601String(),
    };

    final document = await databases.createDocument(
      databaseId: databaseId,
      collectionId: scoreCollectionId,
      documentId: scoreId,
      data: scoreData,
    );

    return ScoreModel.fromMap(document.data);
  }

  Future<List<ScoreModel>> getUserScores(String userId) async {
    try {
    final result = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: scoreCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('timestamp'),
        ],
    );

      return result.documents.map((doc) => ScoreModel.fromMap(doc.data)).toList();
    } catch (e) {
      return [];
    }
  }

  // -------------------- REFLECTION --------------------

  Future<ReflectionModel> createReflection({
    required String sessionId,
    required String userId,
    required String partnerId,
    required String userReflection,
    required String partnerReflection,
    List<String> sharedGratitude = const [],
    List<String> bondingActivities = const [],
  }) async {
    final reflectionId = const Uuid().v4();
    
    final reflectionData = {
      'sessionId': sessionId,
      'userId': userId,
      'partnerId': partnerId,
      'userReflection': userReflection,
      'partnerReflection': partnerReflection,
      'sharedGratitude': sharedGratitude,
      'bondingActivities': bondingActivities,
      'timestamp': DateTime.now().toIso8601String(),
      'isCompleted': true,
    };

    final document = await databases.createDocument(
      databaseId: databaseId,
      collectionId: reflectionCollectionId,
      documentId: reflectionId,
      data: reflectionData,
    );

    return ReflectionModel.fromMap(document.data);
  }

  Future<List<ReflectionModel>> getUserReflections(String userId) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: reflectionCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('timestamp'),
        ],
      );

      return result.documents.map((doc) => ReflectionModel.fromMap(doc.data)).toList();
    } catch (e) {
      return [];
    }
  }

  // -------------------- AUDIO UPLOAD/DOWNLOAD --------------------

  Future<String> uploadAudio(File file) async {
    final result = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path),
    );
    return result.$id;
  }

  Future<Uint8List> downloadAudio(String fileId) async {
    return await storage.getFileView(
      bucketId: bucketId,
      fileId: fileId,
    );
  }

  // -------------------- REALTIME SUBSCRIPTION --------------------

  Stream<dynamic> subscribeToSessions(String userId) {
    return realtime.subscribe([
      'databases.$databaseId.collections.$sessionCollectionId.documents',
    ]).stream;
  }

  Stream<dynamic> subscribeToScores(String userId) {
    return realtime.subscribe([
      'databases.$databaseId.collections.$scoreCollectionId.documents',
    ]).stream;
  }

  Stream<dynamic> subscribeToReflections(String userId) {
    return realtime.subscribe([
      'databases.$databaseId.collections.$reflectionCollectionId.documents',
    ]).stream;
  }

  void subscribeToSession(
    String sessionId,
    void Function(String type, Map<String, dynamic> data) onUpdate,
  ) {
    realtime.subscribe([
      'databases.$databaseId.collections.$reflectionCollectionId.documents',
      'databases.$databaseId.collections.$scoreCollectionId.documents',
    ]).stream.listen((response) {
      final payload = response.payload;
      final event = response.events.first;

      if (payload['sessionId'] != sessionId) return;

      if (event.contains(reflectionCollectionId)) {
        onUpdate('reflection', payload);
      } else if (event.contains(scoreCollectionId)) {
        onUpdate('score', payload);
      }
    });
  }

  // -------------------- UTILITY METHODS --------------------

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(DateTime.now().millisecondsSinceEpoch % chars.length))
    );
  }
}

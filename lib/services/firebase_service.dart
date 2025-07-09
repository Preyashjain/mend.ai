import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../models/score_model.dart';
import '../models/reflection_model.dart';

class FirebaseService {
  static const String projectId = 'mendai-1961b';
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY", // Replace with your Firebase API key
        appId: "YOUR_APP_ID", // Replace with your Firebase App ID
        messagingSenderId: "YOUR_SENDER_ID", // Replace with your Sender ID
        projectId: projectId,
      ),
    );
  }

  // -------------------- AUTH --------------------

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Update display name
    await credential.user?.updateDisplayName(name);
    
    return credential;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // -------------------- USER --------------------

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String gender,
    List<String> relationshipGoals = const [],
    List<String> currentChallenges = const [],
  }) async {
    final userId = _auth.currentUser?.uid ?? const Uuid().v4();
    final inviteCode = _generateInviteCode();
    
    final userData = {
      'name': name,
      'email': email,
      'gender': gender,
      'relationshipGoals': relationshipGoals,
      'currentChallenges': currentChallenges,
      'partnerInviteCode': inviteCode,
      'isOnboarded': true,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('users').doc(userId).set(userData);

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
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserByInviteCode(String inviteCode) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('partnerInviteCode', isEqualTo: inviteCode)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        return UserModel.fromMap(doc.data()..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection('users').doc(userId).update(updates);
  }

  Future<void> connectPartners(String user1Id, String user2Id, String user1Name, String user2Name, String user1Gender, String user2Gender) async {
    final batch = _firestore.batch();
    
    // Update user 1 with partner info
    batch.update(_firestore.collection('users').doc(user1Id), {
      'partnerId': user2Id,
      'partnerName': user2Name,
      'partnerGender': user2Gender,
    });

    // Update user 2 with partner info
    batch.update(_firestore.collection('users').doc(user2Id), {
      'partnerId': user1Id,
      'partnerName': user1Name,
      'partnerGender': user1Gender,
    });

    await batch.commit();
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
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
      'aiPrompts': [],
      'interruptions': [],
    };

    await _firestore.collection('sessions').doc(sessionId).set(sessionData);

    return SessionModel(
      id: sessionId,
      userId: userId,
      partnerId: partnerId,
      timestamp: DateTime.now(),
      status: 'active',
      aiPrompts: [],
      interruptions: [],
    );
  }

  Future<List<SessionModel>> getUserSessions(String userId) async {
    try {
      final query = await _firestore
          .collection('sessions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return SessionModel.fromMap(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateSession(String sessionId, Map<String, dynamic> updates) async {
    await _firestore.collection('sessions').doc(sessionId).update(updates);
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
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('scores').doc(scoreId).set(scoreData);

    return ScoreModel(
      id: scoreId,
      sessionId: sessionId,
      userId: userId,
      partnerId: partnerId,
      userScores: userScores,
      partnerScores: partnerScores,
      userTotalScore: userTotalScore,
      partnerTotalScore: partnerTotalScore,
      userStrengths: userStrengths,
      userSuggestions: userSuggestions,
      partnerStrengths: partnerStrengths,
      partnerSuggestions: partnerSuggestions,
      timestamp: DateTime.now(),
    );
  }

  Future<List<ScoreModel>> getUserScores(String userId) async {
    try {
      final query = await _firestore
          .collection('scores')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ScoreModel.fromMap(data);
      }).toList();
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
      'timestamp': FieldValue.serverTimestamp(),
      'isCompleted': true,
    };

    await _firestore.collection('reflections').doc(reflectionId).set(reflectionData);

    return ReflectionModel(
      id: reflectionId,
      sessionId: sessionId,
      userId: userId,
      partnerId: partnerId,
      userReflection: userReflection,
      partnerReflection: partnerReflection,
      sharedGratitude: sharedGratitude,
      bondingActivities: bondingActivities,
      timestamp: DateTime.now(),
      isCompleted: true,
    );
  }

  Future<List<ReflectionModel>> getUserReflections(String userId) async {
    try {
      final query = await _firestore
          .collection('reflections')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ReflectionModel.fromMap(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // -------------------- REALTIME SUBSCRIPTION --------------------

  Stream<QuerySnapshot> subscribeToSessions(String userId) {
    return _firestore
        .collection('sessions')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> subscribeToScores(String userId) {
    return _firestore
        .collection('scores')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> subscribeToReflections(String userId) {
    return _firestore
        .collection('reflections')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // -------------------- UTILITY METHODS --------------------

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(DateTime.now().millisecondsSinceEpoch % chars.length))
    );
  }
} 
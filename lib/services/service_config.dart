enum BackendType {
  appwrite,
  firebase,
}

class ServiceConfig {
  static BackendType backendType = BackendType.appwrite; // Using Appwrite for now
  
  // Appwrite Configuration
  static const String appwriteEndpoint = 'https://cloud.appwrite.io/v1';
  static const String appwriteProjectId = 'mend-ai-app';
  static const String appwriteDatabaseId = 'mend-ai-db';
  static const String appwriteUsersCollectionId = 'users';
  static const String appwriteSessionsCollectionId = 'sessions';
  static const String appwriteScoresCollectionId = 'scores';
  static const String appwriteReflectionsCollectionId = 'reflections';
  
  // Firebase Configuration
  static const String firebaseProjectId = 'mendai-1961b';
  static const String firebaseApiKey = 'YOUR_API_KEY'; // Replace with your Firebase API key
  static const String firebaseAppId = 'YOUR_APP_ID'; // Replace with your Firebase App ID
  static const String firebaseSenderId = 'YOUR_SENDER_ID'; // Replace with your Sender ID
  
  // Agora Configuration (for voice chat)
  static const String agoraAppId = 'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID
  static const String agoraToken = 'YOUR_AGORA_TOKEN'; // Replace with your Agora Token
  
  // AI Service Configuration
  static const String openaiApiKey = 'YOUR_OPENAI_API_KEY'; // Replace with your OpenAI API key
  
  // Feature Flags
  static const bool enableVoiceChat = true;
  static const bool enableAIModeration = true;
  static const bool enableRealTimeScoring = true;
  static const bool enableInsightsDashboard = true;
  
  // Mock Data (for development without backend)
  static const bool useMockData = false;
} 
# Firebase Setup for Mend AI

## Prerequisites
- Firebase project ID: `mendai-1961b` (already configured)
- Flutter project with Firebase dependencies

## Step 1: Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `mendai-1961b`
3. Enable the following services:
   - **Authentication** (Email/Password)
   - **Firestore Database** (Native mode)
   - **Storage** (optional, for future file uploads)

## Step 2: Get Firebase Configuration

### For Android:
1. In Firebase Console, go to Project Settings
2. Add Android app with package name: `com.example.mend_ai`
3. Download `google-services.json`
4. Replace the placeholder file at `android/app/google-services.json`

### For iOS:
1. In Firebase Console, go to Project Settings
2. Add iOS app with bundle ID: `com.example.mendAi`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/GoogleService-Info.plist`

## Step 3: Update Configuration

Update `lib/services/service_config.dart` with your Firebase credentials:

```dart
// Firebase Configuration
static const String firebaseApiKey = 'YOUR_ACTUAL_API_KEY';
static const String firebaseAppId = 'YOUR_ACTUAL_APP_ID';
static const String firebaseSenderId = 'YOUR_ACTUAL_SENDER_ID';
```

## Step 4: Switch to Firebase Backend

In `lib/services/service_config.dart`, change:

```dart
static BackendType backendType = BackendType.firebase; // Switch from appwrite to firebase
```

## Step 5: Firestore Security Rules

Set up Firestore security rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can read/write sessions they're part of
    match /sessions/{sessionId} {
      allow read, write: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
    }
    
    // Users can read/write scores for their sessions
    match /scores/{scoreId} {
      allow read, write: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
    }
    
    // Users can read/write reflections for their sessions
    match /reflections/{reflectionId} {
      allow read, write: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.partnerId == request.auth.uid);
    }
  }
}
```

## Step 6: Authentication Setup

1. In Firebase Console, go to Authentication > Sign-in method
2. Enable Email/Password authentication
3. Optionally enable Google Sign-in for future features

## Step 7: Test the Setup

1. Run `flutter pub get` to install Firebase dependencies
2. Run `flutter clean && flutter pub get`
3. Test the app with Firebase backend

## Troubleshooting

### Common Issues:

1. **Build errors**: Make sure `google-services.json` is properly placed
2. **Authentication errors**: Check if Email/Password auth is enabled
3. **Firestore permission errors**: Verify security rules are correct
4. **Missing dependencies**: Run `flutter pub get` again

### Switching Between Backends:

To switch back to Appwrite:
```dart
static BackendType backendType = BackendType.appwrite;
```

To use Firebase:
```dart
static BackendType backendType = BackendType.firebase;
```

## Next Steps

1. Set up Agora for voice chat (separate service)
2. Configure OpenAI API for AI features
3. Set up push notifications (optional)
4. Configure analytics (optional)

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Verify all configuration files are correct
3. Ensure all dependencies are properly installed
4. Check Flutter and Firebase documentation 
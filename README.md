# Mend AI - Voice-Based Couples Therapist

A Flutter app that provides couples with a voice-based AI platform to guide natural communication, resolve conflicts, and foster emotional closeness post-resolution.

## 🎯 MVP Features Implemented

### 1. Onboarding Process
- **Personalized Partner Invitation**: Generate unique invite codes and personalized messages
- **Relationship Questionnaire**: Multi-select goals and challenges
- **User Information**: Name and gender input for color-coded interface
- **Seamless Partner Join**: Simple code-based partner connection

### 2. Voice-Based Chat System with AI Moderation
- **Color-Coded Speaking Guide**: 
  - Light blue for Partner A (darker for same-gender couples)
  - Light pink for Partner B (darker for same-gender couples)
- **AI Moderation**: Detects interruptions and provides gentle reminders
- **AI-Driven Questions**: Contextual prompts for conversation guidance
- **Audio Visualization**: Custom waveform display for speaking indicators
- **Real-time Session Management**: Session duration tracking and controls

### 3. Communication Scoring
- **7-Point Scoring System**: Empathy, Listening, Reception, Clarity, Respect, Responsiveness, Open-Mindedness
- **Individual Partner Scores**: Separate scoring for each partner
- **Personalized Feedback**: Strengths and improvement suggestions
- **Score Analytics**: Total and average score calculations

### 4. Post-Resolution Flow
- **Celebratory Experience**: Animated heart and congratulatory messages
- **Gratitude Expression**: Structured appreciation prompts for both partners
- **Shared Reflection**: Collaborative commitment setting
- **Bonding Activities**: AI-suggested quality time activities
- **Progress Tracking**: Automatic saving to insights dashboard

### 5. Insights Dashboard
- **Weekly Summaries**: Session count and average scores
- **Progress Charts**: Visual communication improvement trends
- **Reflection History**: Access to saved post-resolution reflections
- **Performance Analytics**: Detailed scoring breakdowns

## 🎨 Design Features

### Color Scheme
- **Primary**: Teal (#4DB6AC) - Calming and trustworthy
- **Secondary**: Blush Pink (#F8BBD9) - Warm and nurturing
- **Tertiary**: Soft Green (#81C784) - Growth and harmony
- **Background**: Light grays for minimal distraction

### Accessibility
- High-contrast colors for readability
- Clear typography hierarchy
- Voice-first interface design
- Intuitive navigation patterns

## 🏗️ Technical Architecture

### Models
- `UserModel`: User and partner information, relationship data
- `SessionModel`: Voice chat sessions with AI moderation data
- `ScoreModel`: Detailed communication scoring with feedback
- `ReflectionModel`: Post-resolution reflections and activities

### Services
- `AIService`: AI moderation, prompts, emotional tone analysis
- `LocalStorageService`: Data persistence and user management
- `AppwriteService`: Backend integration (configured but not required for MVP)

### Screens
- `OnboardingScreen`: Multi-step user setup
- `PartnerInviteScreen`: Invitation generation and sharing
- `VoiceChatScreen`: Real-time voice communication
- `ScoringScreen`: Communication assessment
- `PostResolutionScreen`: Post-session reflection flow
- `InsightsDashboardScreen`: Progress tracking and analytics

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK (>=3.1.0)
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mend_ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

#### For Voice Chat (Optional)
To enable real-time voice communication:
1. Sign up for Agora.io
2. Get your App ID
3. Replace `"YOUR_AGORA_APP_ID"` in `lib/screens/voice_chat_screen.dart`

#### For Backend Integration (Optional)
To enable cloud data persistence:
1. Set up Appwrite backend
2. Configure `lib/services/appwrite_service.dart`
3. Update environment variables

## 📱 Usage Flow

1. **Onboarding**: User completes questionnaire and invites partner
2. **Partner Join**: Partner uses invite code to connect
3. **Voice Session**: AI-moderated conversation with real-time feedback
4. **Scoring**: Communication assessment with detailed feedback
5. **Post-Resolution**: Gratitude, reflection, and bonding activities
6. **Insights**: Track progress and view historical data

## 🔧 Development

### Project Structure
```
lib/
├── main.dart                 # App entry point and theme
├── models/                   # Data models
├── screens/                  # UI screens
├── services/                 # Business logic
├── utils/                    # Helper functions
└── widgets/                  # Reusable components
```

### Key Dependencies
- `provider`: State management
- `fl_chart`: Progress visualization
- `lottie`: Animations
- `share_plus`: Social sharing
- `permission_handler`: Device permissions

## 🎯 AI Features

### Emotional Tone Analysis
- Keyword-based emotion detection
- Real-time sentiment analysis
- Adaptive response generation

### Conversation Guidance
- Context-aware prompts
- Interruption detection
- Resolution facilitation

### Personalized Feedback
- Score-based suggestions
- Strength identification
- Improvement recommendations

## 📊 MVP Metrics

### Success Indicators
- Complete onboarding flow
- Successful partner connection
- Voice session completion
- Post-resolution reflection
- Dashboard engagement

### Technical Goals
- Smooth voice chat experience
- Accurate interruption detection
- Meaningful scoring system
- Engaging post-resolution flow
- Insightful dashboard analytics

## 🔮 Future Enhancements

### Phase 2 Features
- Advanced AI conversation analysis
- Video chat integration
- Group therapy sessions
- Professional therapist integration
- Advanced analytics and reporting

### Technical Improvements
- Real-time AI processing
- Enhanced voice quality
- Cross-platform synchronization
- Offline mode support
- Advanced security features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Mend AI** - Building stronger relationships through AI-guided communication.

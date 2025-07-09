import 'dart:math';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  // AI Prompts for different conversation stages
  final List<String> _openingPrompts = [
    'What is the main concern you\'d like to address today?',
    'How are you feeling about your relationship right now?',
    'What would you like to improve in your communication?',
    'Is there something specific you\'d like to discuss together?',
  ];

  final List<String> _guidancePrompts = [
    'How do you feel about what your partner just said?',
    'Can you share more about that feeling?',
    'What would help you feel more understood right now?',
    'How can you express that in a way your partner can hear?',
    'What do you think your partner is trying to communicate?',
    'Can you validate your partner\'s feelings before responding?',
  ];

  final List<String> _resolutionPrompts = [
    'What would be a good next step for both of you?',
    'How can you support each other moving forward?',
    'What did you learn about each other today?',
    'What would make you both feel more connected?',
  ];

  final List<String> _interruptionWarnings = [
    'Please let your partner finish their thought before responding.',
    'Take a moment to listen completely before speaking.',
    'Your partner is sharing something important - let them finish.',
    'Practice active listening by waiting for your partner to complete their thought.',
  ];

  // Emotional tone detection (simplified)
  Map<String, double> analyzeEmotionalTone(String text) {
    final words = text.toLowerCase().split(' ');
    Map<String, double> emotions = {
      'anger': 0.0,
      'sadness': 0.0,
      'fear': 0.0,
      'joy': 0.0,
      'surprise': 0.0,
      'disgust': 0.0,
      'neutral': 0.0,
    };

    // Simple keyword-based emotion detection
    final angerWords = ['angry', 'furious', 'mad', 'upset', 'frustrated', 'hate'];
    final sadnessWords = ['sad', 'depressed', 'lonely', 'hurt', 'disappointed', 'crying'];
    final fearWords = ['scared', 'afraid', 'worried', 'anxious', 'nervous', 'terrified'];
    final joyWords = ['happy', 'excited', 'joyful', 'pleased', 'delighted', 'love'];
    final surpriseWords = ['surprised', 'shocked', 'amazed', 'astonished', 'wow'];
    final disgustWords = ['disgusted', 'revolted', 'sick', 'gross', 'hate'];

    for (String word in words) {
      if (angerWords.contains(word)) emotions['anger'] = (emotions['anger'] ?? 0) + 0.2;
      if (sadnessWords.contains(word)) emotions['sadness'] = (emotions['sadness'] ?? 0) + 0.2;
      if (fearWords.contains(word)) emotions['fear'] = (emotions['fear'] ?? 0) + 0.2;
      if (joyWords.contains(word)) emotions['joy'] = (emotions['joy'] ?? 0) + 0.2;
      if (surpriseWords.contains(word)) emotions['surprise'] = (emotions['surprise'] ?? 0) + 0.2;
      if (disgustWords.contains(word)) emotions['disgust'] = (emotions['disgust'] ?? 0) + 0.2;
    }

    // Normalize emotions
    final maxEmotion = emotions.values.reduce(max);
    if (maxEmotion > 0) {
      emotions.forEach((key, value) {
        emotions[key] = value / maxEmotion;
      });
    } else {
      emotions['neutral'] = 1.0;
    }

    return emotions;
  }

  // Get appropriate AI prompt based on conversation stage
  String getPrompt(String stage, {String? context}) {
    switch (stage.toLowerCase()) {
      case 'opening':
        return _openingPrompts[Random().nextInt(_openingPrompts.length)];
      case 'guidance':
        return _guidancePrompts[Random().nextInt(_guidancePrompts.length)];
      case 'resolution':
        return _resolutionPrompts[Random().nextInt(_resolutionPrompts.length)];
      default:
        return _guidancePrompts[Random().nextInt(_guidancePrompts.length)];
    }
  }

  // Get interruption warning
  String getInterruptionWarning(String partnerName) {
    final warning = _interruptionWarnings[Random().nextInt(_interruptionWarnings.length)];
    return warning.replaceAll('your partner', partnerName);
  }

  // Detect if interruption occurred (simplified)
  bool detectInterruption({
    required bool isUserSpeaking,
    required bool isPartnerSpeaking,
    required DateTime lastUserSpeech,
    required DateTime lastPartnerSpeech,
  }) {
    // If both are speaking at the same time (within 1 second)
    final timeDiff = (lastUserSpeech.difference(lastPartnerSpeech)).abs();
    return timeDiff.inSeconds < 1 && isUserSpeaking && isPartnerSpeaking;
  }

  // Generate communication score based on session data
  Map<String, int> generateCommunicationScore({
    required List<String> interruptions,
    required List<String> aiPrompts,
    required int sessionDuration,
    required Map<String, double> emotionalTone,
  }) {
    int baseScore = 70; // Base score

    // Deduct points for interruptions
    baseScore -= interruptions.length * 5;

    // Add points for following AI guidance
    baseScore += aiPrompts.length * 2;

    // Adjust based on emotional tone
    if ((emotionalTone['joy'] ?? 0) > 0.5) baseScore += 10;
    if ((emotionalTone['anger'] ?? 0) > 0.5) baseScore -= 15;
    if ((emotionalTone['sadness'] ?? 0) > 0.5) baseScore -= 10;

    // Ensure score is within bounds
    baseScore = baseScore.clamp(0, 100);

    return {
      'empathy': baseScore + Random().nextInt(20) - 10,
      'listening': baseScore + Random().nextInt(20) - 10,
      'reception': baseScore + Random().nextInt(20) - 10,
      'clarity': baseScore + Random().nextInt(20) - 10,
      'respect': baseScore + Random().nextInt(20) - 10,
      'responsiveness': baseScore + Random().nextInt(20) - 10,
      'openMindedness': baseScore + Random().nextInt(20) - 10,
    };
  }

  // Generate personalized suggestions based on scores
  List<String> generateSuggestions(Map<String, int> scores) {
    List<String> suggestions = [];
    
    scores.forEach((criteria, score) {
      if (score < 50) {
        suggestions.add('Work on improving $criteria - practice active listening and validation.');
      } else if (score < 70) {
        suggestions.add('Continue developing $criteria - you\'re making good progress.');
      } else if (score >= 80) {
        suggestions.add('Excellent $criteria! Keep up the great work.');
      }
    });

    return suggestions;
  }

  // Generate strengths based on scores
  List<String> generateStrengths(Map<String, int> scores) {
    List<String> strengths = [];
    
    scores.forEach((criteria, score) {
      if (score >= 80) {
        strengths.add('Excellent $criteria');
      } else if (score >= 70) {
        strengths.add('Good $criteria');
      }
    });

    return strengths;
  }

  // Get bonding activity suggestions
  List<String> getBondingActivities() {
    return [
      'Take a short walk and talk about something fun',
      'Plan a relaxing evening together',
      'Schedule your next date night',
      'Cook a meal together',
      'Share a favorite memory',
      'Watch a movie you both enjoy',
      'Play a game together',
      'Take a few deep breaths together',
      'Give each other a massage',
      'Write down three things you appreciate about each other',
      'Plan a future vacation or trip',
      'Try a new hobby together',
    ];
  }

  // Get gratitude prompts
  List<String> getGratitudePrompts() {
    return [
      'What\'s one thing your partner did during this conversation that you appreciated?',
      'How did your partner show they care about your feelings?',
      'What did your partner do that made you feel heard?',
      'What quality in your partner are you most grateful for today?',
    ];
  }
} 
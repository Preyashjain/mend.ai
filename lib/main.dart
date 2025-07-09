import 'package:flutter/material.dart';
import 'services/service_config.dart';
import 'services/firebase_service.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/partner_invite_screen.dart';
import 'screens/partner_join_screen.dart';
import 'screens/reflection_screen.dart';
import 'screens/scores_screen.dart';
import 'screens/session_screen.dart';
import 'screens/post_resolution_screen.dart';
import 'screens/insights_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase if using Firebase backend
  if (ServiceConfig.backendType == BackendType.firebase) {
    await FirebaseService.initialize();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MendAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4DB6AC), // Teal
          brightness: Brightness.light,
          primary: const Color(0xFF4DB6AC), // Teal
          secondary: const Color(0xFFF8BBD9), // Blush pink
          tertiary: const Color(0xFF81C784), // Soft green
          surface: const Color(0xFFF5F5F5), // Light gray
          surfaceContainer: const Color(0xFFFAFAFA), // Very light gray
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4DB6AC),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4DB6AC),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
      ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4DB6AC), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E2E2E),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E2E2E),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF616161),
          ),
        ),
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/invite': (context) => const PartnerInviteScreen(),
        '/join': (context) => const PartnerJoinScreen(),
        '/home': (context) => const HomeScreen(),
        '/post-resolution': (context) => const PostResolutionScreen(),
        '/insights': (context) => const InsightsDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/sessions':
            final partnerId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => SessionScreen(partnerId: partnerId),
            );
          case '/reflections':
            final sessionId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ReflectionScreen(sessionId: sessionId),
            );
          case '/scores':
            final sessionId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ScoresScreen(sessionId: sessionId),
            );
          default:
            return null;
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class PostResolutionScreen extends StatefulWidget {
  const PostResolutionScreen({super.key});

  @override
  State<PostResolutionScreen> createState() => _PostResolutionScreenState();
}

class _PostResolutionScreenState extends State<PostResolutionScreen> 
    with TickerProviderStateMixin {
  final LocalStorageService _localStorage = LocalStorageService();
  
  late AnimationController _heartController;
  late AnimationController _fadeController;
  late Animation<double> _heartAnimation;
  late Animation<double> _fadeAnimation;
  
  int _currentStep = 0;
  String _partnerAAppreciation = '';
  String _partnerBAppreciation = '';
  String _movingForwardAction = '';
  
  final List<String> _bondingActivities = [
    'Take a short walk and talk about something fun',
    'Plan a relaxing evening together',
    'Schedule your next date night',
    'Cook a meal together',
    'Share a favorite memory',
    'Watch a movie you both enjoy',
    'Play a game together',
    'Take a few deep breaths together',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCelebration();
  }

  void _initializeAnimations() {
    _heartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _heartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _startCelebration() {
    _heartController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fadeController.forward();
    });
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _fadeController.reset();
      _fadeController.forward();
    } else {
      _completeResolution();
    }
  }

  void _completeResolution() async {
    // Save reflections
    try {
      final sessionId = 'post_resolution_${DateTime.now().millisecondsSinceEpoch}';
      await _localStorage.createReflection(sessionId, '''
Partner A appreciated: $_partnerAAppreciation
Partner B appreciated: $_partnerBAppreciation
Moving forward action: $_movingForwardAction
''');
      
      await _localStorage.createScore(sessionId, 9); // High score for completion
      
      if (mounted) {
        Navigator.pushNamed(context, '/reflections');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Warm background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                      child: _buildCurrentStep(),
                    );
                  },
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildCelebration();
      case 1:
        return _buildAppreciationStep();
      case 2:
        return _buildReflectionStep();
      case 3:
        return _buildBondingStep();
      default:
        return _buildCelebration();
    }
  }

  Widget _buildCelebration() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _heartAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _heartAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFE91E63).withOpacity(0.8),
                        const Color(0xFF4DB6AC).withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Great work!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB6AC),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You\'ve taken an important step toward understanding each other better.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Animated hearts floating up
          ...List.generate(3, (index) => 
            AnimatedBuilder(
              animation: _heartController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    (index - 1) * 50.0,
                    -50 * _heartAnimation.value * (index + 1),
                  ),
                  child: Opacity(
                    opacity: (1 - _heartAnimation.value).clamp(0.0, 1.0),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }

  Widget _buildAppreciationStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Express Gratitude',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB6AC),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Take a moment to thank your partner for their openness and effort in resolving this.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Card(
            color: const Color(0xFF81D4FA).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Partner A\'s Appreciation:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'What did you appreciate about your partner today?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _partnerAAppreciation = value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFFFCDD2).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Partner B\'s Appreciation:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'What did you appreciate about your partner today?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _partnerBAppreciation = value,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shared Reflection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB6AC),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'What\'s one thing you can both do to support each other moving forward?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our commitment moving forward:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'We will support each other by...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    onChanged: (value) => _movingForwardAction = value,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4DB6AC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF4DB6AC)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This reflection will be saved in your insights dashboard for future reference.',
                    style: TextStyle(color: Color(0xFF4DB6AC)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBondingStep() {
    final randomActivity = (_bondingActivities..shuffle()).first;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: Color(0xFFE91E63),
          ),
          const SizedBox(height: 24),
          const Text(
            'Time to Connect',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4DB6AC),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Here\'s a suggestion for quality time together:',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    randomActivity,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DB6AC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Spending quality time together helps strengthen your bond after resolving conflicts.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: const Text('Back'),
            )
          else
            const SizedBox(),
          ElevatedButton(
            onPressed: _nextStep,
            child: Text(_currentStep == 3 ? 'Complete' : 'Continue'),
          ),
        ],
      ),
    );
  }
}
